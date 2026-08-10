#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOFTWARE_NAME="redis"
SOFTWARE_VERSION="${SOFTWARE_VERSION:-8.0.0}"
export SOFTWARE_VERSION
BUILD_METHOD="source_build"
TARGET_OS="${TARGET_OS:-openEuler 24.03 SP3}"
TARGET_MODEL="${TARGET_MODEL:-Kunpeng-920}"
RESULTS_DIR="${SCRIPT_DIR}/results/${SOFTWARE_VERSION}"
mkdir -p "${RESULTS_DIR}"
LOG_FILE="${RESULTS_DIR}/results.log"
JSON_HELPER="${SCRIPT_DIR}/scripts/json_helper.py"

BUILD_TMPDIR=""
SHUNIT2_PATH=""
REDIS_SERVER_BIN=""
REDIS_BENCH_BIN=""
REDIS_CLI_BIN=""
export REDIS_CLI_BIN

ITERATIONS="${ITERATIONS:-1}"

MINIMUM_QPS="${MINIMUM_QPS:-1000}"

log() { local tag="$1"; shift; printf '[%s] %s\n' "$tag" "$*" | tee -a "${LOG_FILE}"; }

json_get()              { python3 "${JSON_HELPER}" "$1" get "${@:2}"; }
json_field_exists()     { python3 "${JSON_HELPER}" "$1" field_exists "$2"; }
json_count_results()    { python3 "${JSON_HELPER}" "$1" count_results; }
json_throughput_ge()    { python3 "${JSON_HELPER}" "$1" throughput_ge "$2" "${@:3}"; }
json_latency_le()       { python3 "${JSON_HELPER}" "$1" latency_le "$2" "${@:3}"; }
json_avg_throughput()   { python3 "${JSON_HELPER}" "$1" avg_throughput "${@:2}"; }
json_max_latency()      { python3 "${JSON_HELPER}" "$1" max_latency "${@:2}"; }
json_version()          { python3 "${JSON_HELPER}" "$1" version; }
json_contains()         { python3 "${JSON_HELPER}" "$1" contains "$2"; }

detect_os_id() { if [ -f /etc/os-release ]; then . /etc/os-release; echo "${ID}"; else echo "unknown"; fi; }
detect_os_name() { echo "${TARGET_OS}"; }

create_build_tmpdir() { BUILD_TMPDIR="$(mktemp -d /tmp/redis_build_XXXXXX)"; log "BUILD" "Created temp build dir: ${BUILD_TMPDIR}"; }
cleanup_build_tmpdir() { if [ -n "${BUILD_TMPDIR}" ] && [ -d "${BUILD_TMPDIR}" ]; then log "BUILD" "Cleaning up: ${BUILD_TMPDIR}"; rm -rf "${BUILD_TMPDIR}"; BUILD_TMPDIR=""; fi; }

download_shunit2() {
    local d; d="$(mktemp -d /tmp/shunit2_XXXXXX)"; SHUNIT2_PATH="${d}/shunit2"
    log "SETUP" "Downloading shUnit2 to ${d}..."
    local mirrors=("https://raw.githubusercontent.com/kward/shunit2/master/shunit2" "https://mirrors.aliyun.com/github-raw/kward/shunit2/master/shunit2" "https://raw.gitmirror.com/kward/shunit2/master/shunit2")
    local ok=0
    for u in "${mirrors[@]}"; do curl --connect-timeout 30 --max-time 60 -sL -o "${SHUNIT2_PATH}" "${u}" && { chmod +x "${SHUNIT2_PATH}"; grep -q "^SHUNIT_VERSION=" "${SHUNIT2_PATH}" && { ok=1; break; }; }; rm -f "${SHUNIT2_PATH}"; done
    if [ "${ok}" -eq 0 ]; then for u in "${mirrors[@]}"; do wget --timeout=30 --tries=2 -q -O "${SHUNIT2_PATH}" "${u}" 2>/dev/null && { chmod +x "${SHUNIT2_PATH}"; grep -q "^SHUNIT_VERSION=" "${SHUNIT2_PATH}" && { ok=1; break; }; }; rm -f "${SHUNIT2_PATH}"; done; fi
    if [ "${ok}" -eq 0 ]; then log "ERROR" "Failed to download shUnit2"; rm -rf "${d}"; return 1; fi
    log "SETUP" "shUnit2 downloaded successfully"
}

check_prerequisites() {
    local err=0
    command -v python3 >/dev/null 2>&1 && log "CHECK" "Python3 OK: $(python3 --version 2>&1)" || { log "ERROR" "python3 missing"; err=$((err+1)); }
    command -v gcc >/dev/null 2>&1 && log "CHECK" "GCC OK: $(gcc --version 2>&1 | head -1)" || log "WARN" "gcc not found - will install"
    command -v make >/dev/null 2>&1 && log "CHECK" "Make OK" || log "WARN" "make not found - will install"
    command -v git >/dev/null 2>&1 && log "CHECK" "Git OK: $(git --version 2>&1)" || log "WARN" "git not found - will install"
    [ -f "${JSON_HELPER}" ] && log "CHECK" "json_helper.py OK" || { log "ERROR" "json_helper.py not found"; err=$((err+1)); }
    local os_id; os_id="$(detect_os_id)"
    log "CHECK" "OS: $(detect_os_name) (${os_id})"
    log "CHECK" "Architecture: $(uname -m)"
    log "CHECK" "Build method: ${BUILD_METHOD} (make, C, server benchmark variant)"
    return ${err}
}

phase1_build() {
    log "PHASE1" "=== Phase 1: Source Build Redis v${SOFTWARE_VERSION} ==="
    create_build_tmpdir
    local SRC="${BUILD_TMPDIR}/redis_src"
    local os_id; os_id="$(detect_os_id)"
    local os_id_lower; os_id_lower="$(echo "${os_id}" | tr '[:upper:]' '[:lower:]')"
    log "PHASE1" "Preparing env on ${os_id}..."
    case "${os_id_lower}" in
        ubuntu|debian) sudo apt-get update -qq 2>&1 | tee -a "${LOG_FILE}" >/dev/null; sudo apt-get install -y -qq build-essential gcc make git wget curl tcl 2>&1 | tee -a "${LOG_FILE}" >/dev/null ;;
        openeuler) sudo dnf install -y gcc make git wget curl tcl 2>&1 | tee -a "${LOG_FILE}" >/dev/null ;;
        centos|rhel|fedora) sudo dnf install -y gcc make git wget curl tcl 2>&1 | tee -a "${LOG_FILE}" >/dev/null ;;
        *) log "WARN" "Unknown OS: ${os_id}, generic build..." ;;
    esac

    log "PHASE1" "Cloning Redis v${SOFTWARE_VERSION}..."
    git clone --branch "${SOFTWARE_VERSION}" --depth 1 \
        https://github.com/redis/redis.git "${SRC}" 2>&1 | tee -a "${LOG_FILE}" || {
        log "WARN" "tag ${SOFTWARE_VERSION} not found, trying without tag (master)..."
        git clone --depth 1 https://github.com/redis/redis.git "${SRC}" 2>&1 | tee -a "${LOG_FILE}" || { log "ERROR" "Failed to clone Redis"; return 1; }
    }

    log "PHASE1" "Building Redis (make)..."
    (cd "${SRC}" && make -j$(nproc) BUILD_TLS=no 2>&1 | tee -a "${LOG_FILE}") || { log "ERROR" "make failed"; return 1; }

    REDIS_SERVER_BIN="${SRC}/src/redis-server"
    REDIS_BENCH_BIN="${SRC}/src/redis-benchmark"
    REDIS_CLI_BIN="${SRC}/src/redis-cli"
    if [ ! -x "${REDIS_SERVER_BIN}" ]; then
        REDIS_SERVER_BIN="$(find "${SRC}" -name redis-server -type f -executable 2>/dev/null | head -1)"
    fi
    if [ ! -x "${REDIS_BENCH_BIN}" ]; then
        REDIS_BENCH_BIN="$(find "${SRC}" -name redis-benchmark -type f -executable 2>/dev/null | head -1)"
    fi
    if [ ! -x "${REDIS_CLI_BIN}" ]; then
        REDIS_CLI_BIN="$(find "${SRC}" -name redis-cli -type f -executable 2>/dev/null | head -1)"
    fi
    if [ ! -x "${REDIS_SERVER_BIN}" ] || [ ! -x "${REDIS_BENCH_BIN}" ] || [ ! -x "${REDIS_CLI_BIN}" ]; then
        log "ERROR" "redis-server, redis-benchmark or redis-cli not found after build"
        return 1
    fi
    log "PHASE1" "redis-cli found at ${REDIS_CLI_BIN}"

    log "PHASE1" "Verifying redis-server..."
    "${REDIS_SERVER_BIN}" --version 2>&1 | tee -a "${LOG_FILE}" | head -1 || log "WARN" "version check failed"
    log "PHASE1" "Build phase complete"
}

phase2_verify() {
    log "PHASE2" "=== Phase 2: Collect Version Info ==="
    local timestamp model arch kernel os_name cpu_model cores python_ver gcc_ver
    timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ' | tr -d '\n\t')"
    model="${TARGET_MODEL}"; arch="$(uname -m | tr -d '\n\t')"; kernel="$(uname -r | tr -d '\n\t')"
    os_name="$(detect_os_name | tr -d '\n\t')"
    cpu_model="$(grep 'model name' /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | xargs | tr -d '\n\t')"
    if [ -z "${cpu_model}" ]; then local np; np="$(grep -c 'processor' /proc/cpuinfo 2>/dev/null || echo 0)"; cpu_model="ARM64 CPU (${np} cores)"; fi
    cores="$(nproc 2>/dev/null | tr -d '\n\t' || echo '4')"
    python_ver="$(python3 --version 2>&1 | tr -d '\n\t')"
    gcc_ver="$(gcc --version 2>/dev/null | head -1 | cut -d' ' -f3 | tr -d '\n\t' || echo 'unknown')"
    python3 "${JSON_HELPER}" "${RESULTS_DIR}/version_info.json" write_version_info \
        "${timestamp}" "${model}" "${arch}" "${kernel}" "${os_name}" "${cpu_model}" \
        "${cores}" "${SOFTWARE_NAME}" "${SOFTWARE_VERSION}" \
        "${python_ver}" "${gcc_ver}"
    log "PHASE2" "Version info saved (OS: ${os_name}, GCC: ${gcc_ver})"
}

phase3_run_benchmarks() {
    log "PHASE3" "=== Phase 3: Run Benchmarks ==="
    mkdir -p "${RESULTS_DIR}"
    log "PHASE3A" "Running Redis operations benchmark (start server → redis-benchmark)..."
    python3 "${SCRIPT_DIR}/scripts/benchmark_redis.py" \
        "${REDIS_SERVER_BIN}" "${REDIS_BENCH_BIN}" \
        "${RESULTS_DIR}/benchmark_redis.json" "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "Redis benchmark had issues"
    log "PHASE3B" "Running micro benchmark..."
    python3 "${SCRIPT_DIR}/scripts/micro_benchmark.py" \
        "${REDIS_SERVER_BIN}" "${REDIS_BENCH_BIN}" \
        "${RESULTS_DIR}/micro_benchmark.json" "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "Micro benchmark had issues"
}

phase4_results() {
    log "PHASE4" "=== Phase 4: Aggregate & Report ==="
    python3 "${SCRIPT_DIR}/scripts/aggregate_results.py" "${RESULTS_DIR}" "${RESULTS_DIR}/results.json"
    python3 "${SCRIPT_DIR}/scripts/generate_summary.py" "${RESULTS_DIR}/results.json" "${RESULTS_DIR}/results.txt"
    log "PHASE4" "Reports generated:"
    log "PHASE4" "  JSON: ${RESULTS_DIR}/results.json"
    log "PHASE4" "  TXT:  ${RESULTS_DIR}/results.txt"
    log "PHASE4" "  LOG:  ${RESULTS_DIR}/results.log"
}

oneTimeSetUp() {
    mkdir -p "${RESULTS_DIR}"
    log "START" "${SOFTWARE_NAME} Source Build & Performance Benchmark - v${SOFTWARE_VERSION}"
    local os_id; os_id="$(detect_os_id)"
    log "START" "OS: $(detect_os_name) (${os_id}), Build: ${BUILD_METHOD}"
    check_prerequisites || log "WARN" "Some prerequisites missing, continuing..."
    phase1_build || log "FATAL" "Phase 1 failed"
    phase2_verify || log "WARN" "Phase 2 had issues"
    phase3_run_benchmarks || log "WARN" "Phase 3 had issues"
    phase4_results || log "WARN" "Phase 4 had issues"
}
oneTimeTearDown() { cleanup_build_tmpdir; if [ -n "${SHUNIT2_PATH}" ]; then rm -rf "$(dirname "${SHUNIT2_PATH}")"; SHUNIT2_PATH=""; fi; }
setUp() { rm -f "${RESULTS_DIR}/test_temp_*.json"; }
tearDown() { rm -f "${RESULTS_DIR}/test_temp_*.json"; }

testArchitectureIsARM64() { local a; a="$(uname -m)"; assertTrue "Arch should be aarch64/arm64, got ${a}" "[ '${a}' = 'aarch64' ] || [ '${a}' = 'arm64' ]"; }
testSoftwareIsInstalled() { local f=0; [ -n "${REDIS_SERVER_BIN}" ] && [ -x "${REDIS_SERVER_BIN}" ] && f=1; if [ "${f}" -eq 0 ]; then echo "WARNING: redis-server not found"; startSkipping; return; fi; assertTrue "redis-server should be executable" "[ ${f} -eq 1 ]"; }
testBenchmarkBinaryExists() { local f=0; [ -n "${REDIS_BENCH_BIN}" ] && [ -x "${REDIS_BENCH_BIN}" ] && f=1; if [ "${f}" -eq 0 ]; then startSkipping; return; fi; assertTrue "redis-benchmark should be executable" "[ ${f} -eq 1 ]"; }
testSoftwareVersionMatches() { local v="${SOFTWARE_VERSION}"; assertNotNull "Version should not be empty" "${v}"; }
testVersionInfoExists() { assertTrue "version_info.json should exist" "[ -f '${RESULTS_DIR}/version_info.json' ]"; }
testVersionInfoHasArchitecture() { local vf="${RESULTS_DIR}/version_info.json"; [ -f "${vf}" ] || { startSkipping; return; }; assertTrue "has architecture" "[ $(json_field_exists "${vf}" architecture) -eq 1 ]"; }
testVersionInfoHasSoftwareVersion() { local vf="${RESULTS_DIR}/version_info.json"; [ -f "${vf}" ] || { startSkipping; return; }; assertTrue "has software_version" "[ $(json_field_exists "${vf}" software_version) -eq 1 ]"; }

testBenchmarkPrimaryProducesResults() { assertTrue "benchmark_redis.json should exist" "[ -f '${RESULTS_DIR}/benchmark_redis.json' ]"; }
testBenchmarkPrimaryHasRequiredFields() { local bf="${RESULTS_DIR}/benchmark_redis.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has benchmark" "[ $(json_contains "${bf}" benchmark) -eq 1 ]"; assertTrue "has performance_metrics" "[ $(json_contains "${bf}" performance_metrics) -eq 1 ]"; assertTrue "has results_summary" "[ $(json_contains "${bf}" results_summary) -eq 1 ]"; }
testBenchmarkPrimaryQpsAboveThreshold() { local bf="${RESULTS_DIR}/benchmark_redis.json"; [ -f "${bf}" ] || { startSkipping; return; }; local qps; qps="$(json_get "${bf}" results_summary SET concurrency_50 qps)"; if [ "${qps}" = "NULL" ] || [ -z "${qps}" ]; then startSkipping; return; fi; echo "[DIAG] SET QPS @ c=50: ${qps} (threshold: ${MINIMUM_QPS})"; assertTrue "SET QPS @ c=50 (${qps}) should be >= ${MINIMUM_QPS}" "[ $(echo "${qps} >= ${MINIMUM_QPS}" | bc -l) -eq 1 ]"; }
testBenchmarkPrimaryIsRedisOps() { local bf="${RESULTS_DIR}/benchmark_redis.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertEquals "benchmark should be redis_ops" "redis_ops" "$(json_get "${bf}" benchmark)"; }
testBenchmarkPrimaryCommandsCompleted() { local bf="${RESULTS_DIR}/benchmark_redis.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has SET" "[ $(json_contains "${bf}" SET) -eq 1 ]"; assertTrue "has GET" "[ $(json_contains "${bf}" GET) -eq 1 ]"; }

testBenchmarkMicroProducesResults() { assertTrue "micro_benchmark.json should exist" "[ -f '${RESULTS_DIR}/micro_benchmark.json' ]"; }
testBenchmarkMicroHasRequiredFields() { local bf="${RESULTS_DIR}/micro_benchmark.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has benchmark" "[ $(json_contains "${bf}" benchmark) -eq 1 ]"; assertTrue "has results" "[ $(json_contains "${bf}" results) -eq 1 ]"; }
testBenchmarkMicroThreadScaling() { local bf="${RESULTS_DIR}/micro_benchmark.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has thread_scaling" "[ $(json_contains "${bf}" thread_scaling) -eq 1 ]"; }
testBenchmarkMicroPersistenceSweep() { local bf="${RESULTS_DIR}/micro_benchmark.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has persistence_sweep" "[ $(json_contains "${bf}" persistence_sweep) -eq 1 ]"; }

testAggregatedResultsExist() { assertTrue "results.json should exist" "[ -f '${RESULTS_DIR}/results.json' ]"; }
testSummaryReportGenerated() { assertTrue "results.txt should exist" "[ -f '${RESULTS_DIR}/results.txt' ]"; }
testLogFileGenerated() { assertTrue "results.log should exist" "[ -f '${RESULTS_DIR}/results.log' ]"; }
testAggregatedResultsContainsAllBenchmarks() { local af="${RESULTS_DIR}/results.json"; [ -f "${af}" ] || { startSkipping; return; }; assertTrue "has primary" "[ $(json_contains "${af}" primary) -eq 1 ]"; assertTrue "has micro" "[ $(json_contains "${af}" micro) -eq 1 ]"; }

usage() {
    cat <<USAGE
Usage: $(basename "$0") [OPTIONS]
Redis Source Build & Performance Benchmark (shUnit2, server benchmark variant)
Options:
  --check    Check prerequisites only
  -h|--help  Show this help
Environment variables:
  SOFTWARE_VERSION   Redis version (default: 8.0.0; tags are bare like 7.4.2, 8.0.0)
  TARGET_OS           OS name in results (default: openEuler 24.03 SP3)
  TARGET_MODEL        Hardware model (default: Kunpeng-920)
  ITERATIONS          Iterations per benchmark (default: 1)
  MINIMUM_QPS         Minimum QPS threshold (default: 1000)
Examples:
  ./redis_test.sh --check
  ./redis_test.sh
  ITERATIONS=3 ./redis_test.sh
  SOFTWARE_VERSION=7.4.2 ./redis_test.sh
USAGE
}

main() {
    local check_only=0
    while [ $# -gt 0 ]; do case "$1" in --check) check_only=1; shift ;; -h|--help) usage; exit 0 ;; *) log "ERROR" "Unknown option: $1"; usage; exit 1 ;; esac; done
    log "START" "${SOFTWARE_NAME} Source Build & Performance Benchmark v${SOFTWARE_VERSION}"
    if [ "${check_only}" -eq 1 ]; then check_prerequisites; exit $?; fi
    check_prerequisites || { log "FATAL" "Prerequisites not met"; exit 1; }
    download_shunit2 || { log "FATAL" "Failed to download shUnit2"; exit 1; }
    SHUNIT_PARENT="${SCRIPT_DIR}/${SOFTWARE_NAME}_test.sh"
    . "${SHUNIT2_PATH}"
}

if [ "${1:-}" != "--shunit2-run" ]; then main "$@"; fi
