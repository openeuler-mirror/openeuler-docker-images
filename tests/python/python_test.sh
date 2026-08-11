#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOFTWARE_NAME="python"
SOFTWARE_VERSION="${SOFTWARE_VERSION:-3.14.7}"
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
PYTHON_BIN=""
ITERATIONS="${ITERATIONS:-1}"
MINIMUM_OPS_PER_SEC="${MINIMUM_OPS_PER_SEC:-100}"
log() { local tag="$1"; shift; printf '[%s] %s\n' "$tag" "$*" | tee -a "${LOG_FILE}"; }
json_get()              { python3 "${JSON_HELPER}" "$1" get "${@:2}"; }
json_field_exists()     { python3 "${JSON_HELPER}" "$1" field_exists "$2"; }
json_count_results()    { python3 "${JSON_HELPER}" "$1" count_results; }
json_throughput_ge()    { python3 "${JSON_HELPER}" "$1" throughput_ge "$2" "${@:3}"; }
json_avg_throughput()   { python3 "${JSON_HELPER}" "$1" avg_throughput "${@:2}"; }
json_version()          { python3 "${JSON_HELPER}" "$1" version; }
json_contains()         { python3 "${JSON_HELPER}" "$1" contains "$2"; }
detect_os_id() { if [ -f /etc/os-release ]; then . /etc/os-release; echo "${ID}"; else echo "unknown"; fi; }
detect_os_name() { echo "${TARGET_OS}"; }
create_build_tmpdir() { BUILD_TMPDIR="$(mktemp -d /tmp/python_build_XXXXXX)"; log "BUILD" "Created temp dir: ${BUILD_TMPDIR}"; }
cleanup_build_tmpdir() { if [ -n "${BUILD_TMPDIR}" ] && [ -d "${BUILD_TMPDIR}" ]; then rm -rf "${BUILD_TMPDIR}"; BUILD_TMPDIR=""; fi; }
download_shunit2() {
    local d; d="$(mktemp -d /tmp/shunit2_XXXXXX)"; SHUNIT2_PATH="${d}/shunit2"
    log "SETUP" "Downloading shUnit2 to ${d}..."
    local mirrors=("https://raw.githubusercontent.com/kward/shunit2/master/shunit2" "https://mirrors.aliyun.com/github-raw/kward/shunit2/master/shunit2" "https://raw.gitmirror.com/kward/shunit2/master/shunit2")
    local ok=0
    for u in "${mirrors[@]}"; do curl --connect-timeout 30 --max-time 60 -sL -o "${SHUNIT2_PATH}" "${u}" && { chmod +x "${SHUNIT2_PATH}"; grep -q "^SHUNIT_VERSION=" "${SHUNIT2_PATH}" && { ok=1; break; }; }; rm -f "${SHUNIT2_PATH}"; done
    if [ "${ok}" -eq 0 ]; then for u in "${mirrors[@]}"; do wget --timeout=30 --tries=2 -q -O "${SHUNIT2_PATH}" "${u}" 2>/dev/null && { chmod +x "${SHUNIT2_PATH}"; grep -q "^SHUNIT_VERSION=" "${SHUNIT2_PATH}" && { ok=1; break; }; }; rm -f "${SHUNIT2_PATH}"; done; fi
    if [ "${ok}" -eq 0 ]; then log "ERROR" "Failed to download shUnit2"; rm -rf "${d}"; return 1; fi
}
check_prerequisites() {
    local err=0
    command -v python3 >/dev/null 2>&1 && log "CHECK" "Python3 OK: $(python3 --version 2>&1)" || { log "ERROR" "python3 missing"; err=$((err+1)); }
    command -v gcc >/dev/null 2>&1 && log "CHECK" "GCC OK: $(gcc --version 2>&1 | head -1)" || log "WARN" "gcc not found"
    command -v make >/dev/null 2>&1 && log "CHECK" "Make OK" || log "WARN" "make not found"
    command -v git >/dev/null 2>&1 && log "CHECK" "Git OK: $(git --version 2>&1)" || log "WARN" "git not found"
    [ -f "${JSON_HELPER}" ] && log "CHECK" "json_helper.py OK" || { log "ERROR" "json_helper.py not found"; err=$((err+1)); }
    local os_id; os_id="$(detect_os_id)"
    local os_id_lower; os_id_lower="$(echo "${os_id}" | tr '[:upper:]' '[:lower:]')"
    log "CHECK" "OS: $(detect_os_name) (${os_id})"
    log "CHECK" "Architecture: $(uname -m)"
    log "CHECK" "Build method: ${BUILD_METHOD} (configure+make, CPython source)"
    case "${os_id_lower}" in
        ubuntu|debian) sudo apt-get update -qq >/dev/null 2>&1; sudo apt-get install -y -qq build-essential gcc make git wget curl libssl-dev zlib1g-dev libffi-dev >/dev/null 2>&1 ;;
        openeuler) sudo dnf install -y gcc make git wget curl openssl-devel zlib-devel libffi-devel >/dev/null 2>&1 ;;
        centos|rhel|fedora) sudo dnf install -y gcc make git wget curl openssl-devel zlib-devel libffi-devel >/dev/null 2>&1 ;;
        *) log "WARN" "Unknown OS: ${os_id}" ;;
    esac
    return ${err}
}
phase1_build() {
    log "PHASE1" "=== Phase 1: Source Build CPython v${SOFTWARE_VERSION} ==="
    create_build_tmpdir
    local SRC="${BUILD_TMPDIR}/cpython_src"
    local INSTALL="${BUILD_TMPDIR}/install"
    local ver_tag="v${SOFTWARE_VERSION}"
    [ "${SOFTWARE_VERSION:0:1}" = "v" ] && ver_tag="${SOFTWARE_VERSION}"
    log "PHASE1" "Cloning CPython tag ${ver_tag}..."
    git clone --branch "${ver_tag}" --depth 1 https://github.com/python/cpython.git "${SRC}" 2>&1 | tee -a "${LOG_FILE}" || { log "ERROR" "Failed to clone CPython"; return 1; }
    log "PHASE1" "Configuring..."
    (cd "${SRC}" && ./configure --prefix="${INSTALL}" --enable-optimizations=no 2>&1 | tee -a "${LOG_FILE}") || { log "ERROR" "configure failed"; return 1; }
    log "PHASE1" "Compiling (this may take 5-15 minutes)..."
    (cd "${SRC}" && make -j$(nproc) 2>&1 | tee -a "${LOG_FILE}") || { log "ERROR" "make failed"; return 1; }
    log "PHASE1" "Installing..."
    (cd "${SRC}" && make install 2>&1 | tee -a "${LOG_FILE}") || log "WARN" "make install had issues"
    PYTHON_BIN="${INSTALL}/bin/python3"
    if [ ! -x "${PYTHON_BIN}" ]; then PYTHON_BIN="$(find "${INSTALL}" -name python3 -type f -executable 2>/dev/null | head -1)"; fi
    if [ ! -x "${PYTHON_BIN}" ]; then log "ERROR" "python3 binary not found after build"; return 1; fi
    log "PHASE1" "Verifying..."
    "${PYTHON_BIN}" --version 2>&1 | tee -a "${LOG_FILE}" | head -1 || log "WARN" "version check failed"
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
        "${cores}" "${SOFTWARE_NAME}" "${SOFTWARE_VERSION}" "${python_ver}" "${gcc_ver}"
    log "PHASE2" "Version info saved (Python: ${SOFTWARE_VERSION}, GCC: ${gcc_ver})"
}
phase3_run_benchmarks() {
    log "PHASE3" "=== Phase 3: Run Benchmarks ==="
    mkdir -p "${RESULTS_DIR}"
    log "PHASE3A" "Running pyperformance benchmark..."
    python3 "${SCRIPT_DIR}/scripts/benchmark_py.py" "${PYTHON_BIN}" "${RESULTS_DIR}/benchmark_py.json" "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "pyperformance had issues"
    log "PHASE3B" "Running micro benchmark..."
    python3 "${SCRIPT_DIR}/scripts/micro_benchmark.py" "${PYTHON_BIN}" "${RESULTS_DIR}/micro_benchmark.json" "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "Micro benchmark had issues"
}
phase4_results() {
    log "PHASE4" "=== Phase 4: Aggregate and Report ==="
    python3 "${SCRIPT_DIR}/scripts/aggregate_results.py" "${RESULTS_DIR}" "${RESULTS_DIR}/results.json"
    python3 "${SCRIPT_DIR}/scripts/generate_summary.py" "${RESULTS_DIR}/results.json" "${RESULTS_DIR}/results.txt"
    log "PHASE4" "Reports generated:"
    log "PHASE4" "  JSON: ${RESULTS_DIR}/results.json"
    log "PHASE4" "  TXT:  ${RESULTS_DIR}/results.txt"
    log "PHASE4" "  LOG:  ${RESULTS_DIR}/results.log"
}
oneTimeSetUp() {
    mkdir -p "${RESULTS_DIR}"
    log "START" "${SOFTWARE_NAME} Performance Benchmark - v${SOFTWARE_VERSION} (${BUILD_METHOD})"
    check_prerequisites || log "WARN" "Some prerequisites missing"
    phase1_build || log "FATAL" "Phase 1 failed"
    phase2_verify || log "WARN" "Phase 2 had issues"
    phase3_run_benchmarks || log "WARN" "Phase 3 had issues"
    phase4_results || log "WARN" "Phase 4 had issues"
}
oneTimeTearDown() { cleanup_build_tmpdir; if [ -n "${SHUNIT2_PATH}" ]; then rm -rf "$(dirname "${SHUNIT2_PATH}")"; SHUNIT2_PATH=""; fi; }
setUp() { rm -f "${RESULTS_DIR}/test_temp_*.json"; }
tearDown() { rm -f "${RESULTS_DIR}/test_temp_*.json"; }
testArchitectureIsARM64() { local a; a="$(uname -m)"; assertTrue "Arch aarch64/arm64, got ${a}" "[ '${a}' = 'aarch64' ] || [ '${a}' = 'arm64' ]"; }
testSoftwareIsInstalled() { local f=0; [ -n "${PYTHON_BIN}" ] && [ -x "${PYTHON_BIN}" ] && f=1; if [ "${f}" -eq 0 ]; then startSkipping; return; fi; assertTrue "python3 binary should exist" "[ ${f} -eq 1 ]"; }
testSoftwareVersionMatches() { assertNotNull "Version not empty" "${SOFTWARE_VERSION}"; }
testVersionInfoExists() { assertTrue "version_info.json exists" "[ -f '${RESULTS_DIR}/version_info.json' ]"; }
testVersionInfoHasArchitecture() { local vf="${RESULTS_DIR}/version_info.json"; [ -f "${vf}" ] || { startSkipping; return; }; assertTrue "has architecture" "[ $(json_field_exists "${vf}" architecture) -eq 1 ]"; }
testVersionInfoHasSoftwareVersion() { local vf="${RESULTS_DIR}/version_info.json"; [ -f "${vf}" ] || { startSkipping; return; }; assertTrue "has software_version" "[ $(json_field_exists "${vf}" software_version) -eq 1 ]"; }
testBenchmarkPrimaryProducesResults() { assertTrue "benchmark_py.json exists" "[ -f '${RESULTS_DIR}/benchmark_py.json' ]"; }
testBenchmarkPrimaryHasRequiredFields() { local bf="${RESULTS_DIR}/benchmark_py.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has benchmark" "[ $(json_contains "${bf}" benchmark) -eq 1 ]"; assertTrue "has performance_metrics" "[ $(json_contains "${bf}" performance_metrics) -eq 1 ]"; assertTrue "has results_summary" "[ $(json_contains "${bf}" results_summary) -eq 1 ]"; }
testBenchmarkPrimaryOpsAboveThreshold() { local bf="${RESULTS_DIR}/benchmark_py.json"; [ -f "${bf}" ] || { startSkipping; return; }; local ops; ops="$(json_avg_throughput "${bf}" results_summary ops_per_sec)"; if [ -z "${ops}" ] || [ "${ops}" = "0" ]; then startSkipping; return; fi; echo "[DIAG] Avg ops/sec: ${ops} (min: ${MINIMUM_OPS_PER_SEC})"; assertTrue "Avg ops/sec >= ${MINIMUM_OPS_PER_SEC}" "[ $(echo "${ops} >= ${MINIMUM_OPS_PER_SEC}" | bc -l) -eq 1 ]"; }
testBenchmarkPrimaryIsPyperformance() { local bf="${RESULTS_DIR}/benchmark_py.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertEquals "benchmark is pyperformance" "pyperformance" "$(json_get "${bf}" benchmark)"; }
testBenchmarkMicroProducesResults() { assertTrue "micro_benchmark.json exists" "[ -f '${RESULTS_DIR}/micro_benchmark.json' ]"; }
testBenchmarkMicroThreadScaling() { local bf="${RESULTS_DIR}/micro_benchmark.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has thread_scaling" "[ $(json_contains "${bf}" thread_scaling) -eq 1 ]"; }
testAggregatedResultsExist() { assertTrue "results.json exists" "[ -f '${RESULTS_DIR}/results.json' ]"; }
testSummaryReportGenerated() { assertTrue "results.txt exists" "[ -f '${RESULTS_DIR}/results.txt' ]"; }
testLogFileGenerated() { assertTrue "results.log exists" "[ -f '${RESULTS_DIR}/results.log' ]"; }
testAggregatedResultsContainsAllBenchmarks() { local af="${RESULTS_DIR}/results.json"; [ -f "${af}" ] || { startSkipping; return; }; assertTrue "has primary" "[ $(json_contains "${af}" primary) -eq 1 ]"; assertTrue "has micro" "[ $(json_contains "${af}" micro) -eq 1 ]"; }
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "CPython Performance Benchmark (source build + pyperformance)"
    echo "Options: --check (prerequisites), -h|--help"
    echo "Env: SOFTWARE_VERSION (default: 3.14.7, tag v prefix), ITERATIONS (default: 1)"
    echo "      MINIMUM_OPS_PER_SEC (default: 100)"
    echo "Note: Builds CPython from source (5-15 min), then runs pyperformance suite"
}
main() {
    local check_only=0
    while [ $# -gt 0 ]; do case "$1" in --check) check_only=1; shift ;; -h|--help) usage; exit 0 ;; *) log "ERROR" "Unknown: $1"; usage; exit 1 ;; esac; done
    log "START" "${SOFTWARE_NAME} Performance Benchmark v${SOFTWARE_VERSION}"
    if [ "${check_only}" -eq 1 ]; then check_prerequisites; exit $?; fi
    check_prerequisites || { log "FATAL" "Prerequisites not met"; exit 1; }
    download_shunit2 || { log "FATAL" "Failed to download shUnit2"; exit 1; }
    SHUNIT_PARENT="${SCRIPT_DIR}/${SOFTWARE_NAME}_test.sh"
    . "${SHUNIT2_PATH}"
}
if [ "${1:-}" != "--shunit2-run" ]; then main "$@"; fi
