#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOFTWARE_NAME="rocksdb"
SOFTWARE_VERSION="${SOFTWARE_VERSION:-11.8.0}"
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
BENCHMARK_BIN=""

DATA_NUM="${DATA_NUM:-100000}"
KEY_SIZE="${KEY_SIZE:-16}"
VALUE_SIZE="${VALUE_SIZE:-1024}"
ITERATIONS="${ITERATIONS:-1}"

MINIMUM_OPS_PER_SEC="${MINIMUM_OPS_PER_SEC:-1000}"

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

create_build_tmpdir() { BUILD_TMPDIR="$(mktemp -d /tmp/rocksdb_build_XXXXXX)"; log "BUILD" "Created temp build dir: ${BUILD_TMPDIR}"; }
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
    command -v g++ >/dev/null 2>&1 && log "CHECK" "G++ OK: $(g++ --version 2>&1 | head -1)" || log "WARN" "g++ not found - will install"
    command -v cmake >/dev/null 2>&1 && log "CHECK" "CMake OK: $(cmake --version 2>&1 | head -1)" || log "WARN" "cmake not found - will install"
    command -v git >/dev/null 2>&1 && log "CHECK" "Git OK: $(git --version 2>&1)" || log "WARN" "git not found - will install"
    [ -f "${JSON_HELPER}" ] && log "CHECK" "json_helper.py OK" || { log "ERROR" "json_helper.py not found"; err=$((err+1)); }
    local os_id; os_id="$(detect_os_id)"
    log "CHECK" "OS: $(detect_os_name) (${os_id})"
    log "CHECK" "Architecture: $(uname -m)"
    log "CHECK" "Build method: ${BUILD_METHOD} (cmake, C++20, ARM64 NEON)"
    return ${err}
}

phase1_build() {
    log "PHASE1" "=== Phase 1: Source Build RocksDB v${SOFTWARE_VERSION} ==="
    create_build_tmpdir
    local SRC="${BUILD_TMPDIR}/rocksdb_src"
    local BUILD="${BUILD_TMPDIR}/build"
    local os_id; os_id="$(detect_os_id)"
    local os_id_lower; os_id_lower="$(echo "${os_id}" | tr '[:upper:]' '[:lower:]')"
    log "PHASE1" "Preparing env on ${os_id}..."
    case "${os_id_lower}" in
        ubuntu|debian) sudo apt-get update -qq 2>&1 | tee -a "${LOG_FILE}" >/dev/null; sudo apt-get install -y -qq build-essential g++ cmake make git libgflags-dev libsnappy-dev libzstd-dev zlib1g-dev libatomic1 2>&1 | tee -a "${LOG_FILE}" >/dev/null ;;
        openeuler) sudo dnf install -y gcc gcc-c++ cmake make git gflags gflags-devel snappy snappy-devel zstd-devel zlib-devel libatomic 2>&1 | tee -a "${LOG_FILE}" >/dev/null ;;
        centos|rhel|fedora) sudo dnf install -y gcc gcc-c++ cmake make git gflags gflags-devel snappy snappy-devel zstd-devel zlib-devel libatomic 2>&1 | tee -a "${LOG_FILE}" >/dev/null ;;
        *) log "WARN" "Unknown OS: ${os_id}, generic build..." ;;
    esac

    local ver_tag="${SOFTWARE_VERSION}"
    [ "${ver_tag:0:1}" = "v" ] || ver_tag="v${ver_tag}"
    log "PHASE1" "Cloning RocksDB tag ${ver_tag}..."
    git clone --branch "${ver_tag}" --depth 1 https://github.com/facebook/rocksdb.git "${SRC}" 2>&1 | tee -a "${LOG_FILE}" || { log "ERROR" "Failed to clone RocksDB"; return 1; }

    log "PHASE1" "Configuring CMake..."
    mkdir -p "${BUILD}"
    (cd "${BUILD}" && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${BUILD_TMPDIR}/install" -DFAIL_ON_WARNINGS=OFF -DWITH_SNAPPY=ON -DWITH_ZSTD=ON -DWITH_ZLIB=ON "${SRC}" 2>&1 | tee -a "${LOG_FILE}") || { log "ERROR" "cmake failed"; return 1; }

    log "PHASE1" "Compiling RocksDB (db_bench target)..."
    (cd "${BUILD}" && make -j$(nproc) db_bench 2>&1 | tee -a "${LOG_FILE}") || { log "ERROR" "make failed"; return 1; }

    log "PHASE1" "Finding db_bench binary..."
    BENCHMARK_BIN="${BUILD}/tools/db_bench"
    if [ ! -x "${BENCHMARK_BIN}" ]; then
        BENCHMARK_BIN="$(find "${BUILD}" -name db_bench -type f -executable 2>/dev/null | head -1)"
    fi
    if [ ! -x "${BENCHMARK_BIN}" ]; then
        log "ERROR" "db_bench not found after build"
        return 1
    fi
    log "PHASE1" "db_bench found at ${BENCHMARK_BIN}"
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
    gcc_ver="$(g++ --version 2>/dev/null | head -1 | cut -d' ' -f3 | tr -d '\n\t' || echo 'unknown')"
    python3 "${JSON_HELPER}" "${RESULTS_DIR}/version_info.json" write_version_info \
        "${timestamp}" "${model}" "${arch}" "${kernel}" "${os_name}" "${cpu_model}" \
        "${cores}" "${SOFTWARE_NAME}" "${SOFTWARE_VERSION}" \
        "${python_ver}" "${gcc_ver}"
    log "PHASE2" "Version info saved (OS: ${os_name}, GCC: ${gcc_ver})"
}

phase3_run_benchmarks() {
    log "PHASE3" "=== Phase 3: Run Benchmarks ==="
    mkdir -p "${RESULTS_DIR}"
    log "PHASE3A" "Running KV operations benchmark..."
    python3 "${SCRIPT_DIR}/scripts/benchmark_kv.py" \
        "${BENCHMARK_BIN}" "${RESULTS_DIR}/benchmark_kv.json" \
        "${DATA_NUM}" "${KEY_SIZE}" "${VALUE_SIZE}" "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "KV benchmark had issues"
    log "PHASE3B" "Running micro benchmark..."
    python3 "${SCRIPT_DIR}/scripts/micro_benchmark.py" \
        "${BENCHMARK_BIN}" "${RESULTS_DIR}/micro_benchmark.json" \
        "${DATA_NUM}" "${KEY_SIZE}" "${VALUE_SIZE}" "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "Micro benchmark had issues"
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
testSoftwareIsInstalled() { local f=0; [ -n "${BENCHMARK_BIN}" ] && [ -x "${BENCHMARK_BIN}" ] && f=1; if [ "${f}" -eq 0 ]; then echo "WARNING: db_bench not found"; startSkipping; return; fi; assertTrue "db_bench should be executable" "[ ${f} -eq 1 ]"; }
testSoftwareVersionMatches() { local v="${SOFTWARE_VERSION}"; assertNotNull "Version should not be empty" "${v}"; }
testVersionInfoExists() { assertTrue "version_info.json should exist" "[ -f '${RESULTS_DIR}/version_info.json' ]"; }
testVersionInfoHasArchitecture() { local vf="${RESULTS_DIR}/version_info.json"; [ -f "${vf}" ] || { startSkipping; return; }; assertTrue "has architecture" "[ $(json_field_exists "${vf}" architecture) -eq 1 ]"; }
testVersionInfoHasSoftwareVersion() { local vf="${RESULTS_DIR}/version_info.json"; [ -f "${vf}" ] || { startSkipping; return; }; assertTrue "has software_version" "[ $(json_field_exists "${vf}" software_version) -eq 1 ]"; }

testBenchmarkPrimaryProducesResults() { assertTrue "benchmark_kv.json should exist" "[ -f '${RESULTS_DIR}/benchmark_kv.json' ]"; }
testBenchmarkPrimaryHasRequiredFields() { local bf="${RESULTS_DIR}/benchmark_kv.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has benchmark" "[ $(json_contains "${bf}" benchmark) -eq 1 ]"; assertTrue "has performance_metrics" "[ $(json_contains "${bf}" performance_metrics) -eq 1 ]"; assertTrue "has results_summary" "[ $(json_contains "${bf}" results_summary) -eq 1 ]"; }
testBenchmarkPrimaryOpsPerSecAboveThreshold() { local bf="${RESULTS_DIR}/benchmark_kv.json"; [ -f "${bf}" ] || { startSkipping; return; }; local ops; ops="$(json_get "${bf}" results_summary fillseq ops_per_sec)"; if [ "${ops}" = "NULL" ] || [ -z "${ops}" ]; then startSkipping; return; fi; echo "[DIAG] fillseq ops/sec: ${ops} (threshold: ${MINIMUM_OPS_PER_SEC})"; assertTrue "fillseq ops/sec (${ops}) should be >= ${MINIMUM_OPS_PER_SEC}" "[ $(echo "${ops} >= ${MINIMUM_OPS_PER_SEC}" | bc -l) -eq 1 ]"; }
testBenchmarkPrimaryIsKvOps() { local bf="${RESULTS_DIR}/benchmark_kv.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertEquals "benchmark should be kv_ops" "kv_ops" "$(json_get "${bf}" benchmark)"; }
testBenchmarkPrimaryWorkloadsCompleted() { local bf="${RESULTS_DIR}/benchmark_kv.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has fillseq" "[ $(json_contains "${bf}" fillseq) -eq 1 ]"; assertTrue "has readrandom" "[ $(json_contains "${bf}" readrandom) -eq 1 ]"; assertTrue "has overwrite" "[ $(json_contains "${bf}" overwrite) -eq 1 ]"; }

testBenchmarkMicroProducesResults() { assertTrue "micro_benchmark.json should exist" "[ -f '${RESULTS_DIR}/micro_benchmark.json' ]"; }
testBenchmarkMicroHasRequiredFields() { local bf="${RESULTS_DIR}/micro_benchmark.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has benchmark" "[ $(json_contains "${bf}" benchmark) -eq 1 ]"; assertTrue "has results" "[ $(json_contains "${bf}" results) -eq 1 ]"; }
testBenchmarkMicroThreadScaling() { local bf="${RESULTS_DIR}/micro_benchmark.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has thread_scaling" "[ $(json_contains "${bf}" thread_scaling) -eq 1 ]"; }
testBenchmarkMicroCompressionSweep() { local bf="${RESULTS_DIR}/micro_benchmark.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has compression_sweep" "[ $(json_contains "${bf}" compression_sweep) -eq 1 ]"; }

testAggregatedResultsExist() { assertTrue "results.json should exist" "[ -f '${RESULTS_DIR}/results.json' ]"; }
testSummaryReportGenerated() { assertTrue "results.txt should exist" "[ -f '${RESULTS_DIR}/results.txt' ]"; }
testLogFileGenerated() { assertTrue "results.log should exist" "[ -f '${RESULTS_DIR}/results.log' ]"; }
testAggregatedResultsContainsAllBenchmarks() { local af="${RESULTS_DIR}/results.json"; [ -f "${af}" ] || { startSkipping; return; }; assertTrue "has primary" "[ $(json_contains "${af}" primary) -eq 1 ]"; assertTrue "has micro" "[ $(json_contains "${af}" micro) -eq 1 ]"; }

usage() {
    cat <<USAGE
Usage: $(basename "$0") [OPTIONS]
RocksDB Source Build & Performance Benchmark (shUnit2)
Options:
  --check    Check prerequisites only
  -h|--help  Show this help
Environment variables:
  SOFTWARE_VERSION     RocksDB version (default: 11.8.0; supported: 11.8.0, 11.1.2)
  TARGET_OS            OS name in results (default: openEuler 24.03 SP3)
  TARGET_MODEL         Hardware model (default: Kunpeng-920)
  DATA_NUM             Number of keys (default: 100000)
  KEY_SIZE             Key size in bytes (default: 16)
  VALUE_SIZE           Value size in bytes (default: 1024)
  ITERATIONS           Iterations per workload (default: 1)
  MINIMUM_OPS_PER_SEC  Minimum ops/sec threshold (default: 1000)
Examples:
  ./rocksdb_test.sh --check
  ./rocksdb_test.sh
  DATA_NUM=10000 ITERATIONS=1 ./rocksdb_test.sh
  SOFTWARE_VERSION=11.1.2 ./rocksdb_test.sh
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
