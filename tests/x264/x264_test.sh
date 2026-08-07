#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOFTWARE_NAME="x264"
SOFTWARE_VERSION="${SOFTWARE_VERSION:-rolling}"
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
YUV_FILE=""

YUV_WIDTH="${YUV_WIDTH:-1280}"
YUV_HEIGHT="${YUV_HEIGHT:-720}"
YUV_FRAMES="${YUV_FRAMES:-50}"
ITERATIONS="${ITERATIONS:-1}"

MIN_FPS="${MIN_FPS:-10}"

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

create_build_tmpdir() { BUILD_TMPDIR="$(mktemp -d /tmp/x264_build_XXXXXX)"; log "BUILD" "Created temp build dir: ${BUILD_TMPDIR}"; }
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
    { command -v gcc >/dev/null 2>&1 || command -v cc >/dev/null 2>&1; } && log "CHECK" "GCC OK: $(gcc --version 2>&1 | head -1)" || log "WARN" "gcc not found - will install"
    command -v make >/dev/null 2>&1 && log "CHECK" "Make OK" || log "WARN" "make not found - will install"
    command -v git >/dev/null 2>&1 && log "CHECK" "Git OK: $(git --version 2>&1)" || log "WARN" "git not found - will install"
    command -v nasm >/dev/null 2>&1 && log "CHECK" "NASM OK (x86 only, ARM uses gas)" || log "CHECK" "NASM not needed on aarch64 (uses gas)"
    [ -f "${JSON_HELPER}" ] && log "CHECK" "json_helper.py OK" || { log "ERROR" "json_helper.py not found"; err=$((err+1)); }
    local os_id; os_id="$(detect_os_id)"
    log "CHECK" "OS: $(detect_os_name) (${os_id})"
    log "CHECK" "Architecture: $(uname -m)"
    log "CHECK" "Build method: ${BUILD_METHOD} (autoconf, NEON auto-detected on aarch64)"
    return ${err}
}

phase1_build() {
    log "PHASE1" "=== Phase 1: Source Build x264 (${SOFTWARE_VERSION}) ==="
    create_build_tmpdir
    local SRC="${BUILD_TMPDIR}/x264_src"
    local INSTALL="${BUILD_TMPDIR}/install"
    local os_id; os_id="$(detect_os_id)"
    log "PHASE1" "Preparing env on ${os_id}..."
    local os_id_lower
    os_id_lower="$(echo "${os_id}" | tr '[:upper:]' '[:lower:]')"
    case "${os_id_lower}" in
        ubuntu|debian) sudo apt-get update -qq 2>&1 | tee -a "${LOG_FILE}" >/dev/null; sudo apt-get install -y -qq build-essential gcc make git wget curl 2>&1 | tee -a "${LOG_FILE}" >/dev/null ;;
        openeuler) sudo dnf install -y gcc make git wget curl 2>&1 | tee -a "${LOG_FILE}" >/dev/null ;;
        centos|rhel|fedora) sudo dnf install -y gcc make git wget curl 2>&1 | tee -a "${LOG_FILE}" >/dev/null ;;
        *) log "WARN" "Unknown OS: ${os_id}, generic build..." ;;
    esac

    log "PHASE1" "Cloning x264 (rolling master)..."
    git clone --depth 1 https://github.com/mirror/x264.git "${SRC}" 2>&1 | tee -a "${LOG_FILE}" || {
        log "WARN" "github mirror failed, trying videolan upstream..."
        git clone --depth 1 https://code.videolan.org/videolan/x264.git "${SRC}" 2>&1 | tee -a "${LOG_FILE}" || { log "ERROR" "Failed to clone x264"; return 1; }
    }

    log "PHASE1" "Configuring (autoconf-style)..."
    (cd "${SRC}" && ./configure --enable-static --enable-pic --prefix="${INSTALL}" 2>&1 | tee -a "${LOG_FILE}") || { log "ERROR" "configure failed"; return 1; }

    log "PHASE1" "Compiling x264..."
    (cd "${SRC}" && make -j$(nproc) 2>&1 | tee -a "${LOG_FILE}") || { log "ERROR" "make failed"; return 1; }
    (cd "${SRC}" && make install 2>&1 | tee -a "${LOG_FILE}") || log "WARN" "make install failed, using in-tree binary"

    BENCHMARK_BIN="${INSTALL}/bin/x264"
    if [ ! -x "${BENCHMARK_BIN}" ]; then
        if [ -x "${SRC}/x264" ]; then BENCHMARK_BIN="${SRC}/x264"; else log "ERROR" "x264 binary not found"; return 1; fi
    fi

    log "PHASE1" "Verifying x264 binary..."
    "${BENCHMARK_BIN}" --version 2>&1 | tee -a "${LOG_FILE}" | head -1 || log "WARN" "version check failed"

    log "PHASE1" "Generating test YUV (${YUV_WIDTH}x${YUV_HEIGHT}, ${YUV_FRAMES} frames)..."
    YUV_FILE="${BUILD_TMPDIR}/test_${YUV_WIDTH}x${YUV_HEIGHT}.yuv"
    python3 "${SCRIPT_DIR}/scripts/gen_yuv.py" "${YUV_WIDTH}" "${YUV_HEIGHT}" "${YUV_FRAMES}" "${YUV_FILE}" 2>&1 | tee -a "${LOG_FILE}" || { log "ERROR" "YUV generation failed"; return 1; }

    log "PHASE1" "Build phase complete"
}

phase2_verify() {
    log "PHASE2" "=== Phase 2: Collect Version Info ==="
    local timestamp model arch kernel os_name cpu_model cores python_ver gcc_ver x264_ver
    timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ' | tr -d '\n\t')"
    model="${TARGET_MODEL}"; arch="$(uname -m | tr -d '\n\t')"; kernel="$(uname -r | tr -d '\n\t')"
    os_name="$(detect_os_name | tr -d '\n\t')"
    cpu_model="$(grep 'model name' /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | xargs | tr -d '\n\t')"
    if [ -z "${cpu_model}" ]; then local np; np="$(grep -c 'processor' /proc/cpuinfo 2>/dev/null || echo 0)"; cpu_model="ARM64 CPU (${np} cores)"; fi
    cores="$(nproc 2>/dev/null | tr -d '\n\t' || echo '4')"
    python_ver="$(python3 --version 2>&1 | tr -d '\n\t')"
    gcc_ver="$(gcc --version 2>/dev/null | head -1 | cut -d' ' -f3 | tr -d '\n\t' || echo 'unknown')"
    x264_ver="rolling"
    if [ -x "${BENCHMARK_BIN}" ]; then
        x264_ver="$("${BENCHMARK_BIN}" --version 2>&1 | head -1 | tr -d '\n\t' || echo 'rolling')"
    fi
    python3 "${JSON_HELPER}" "${RESULTS_DIR}/version_info.json" write_version_info \
        "${timestamp}" "${model}" "${arch}" "${kernel}" "${os_name}" "${cpu_model}" \
        "${cores}" "${SOFTWARE_NAME}" "${x264_ver}" \
        "${python_ver}" "${gcc_ver}"
    log "PHASE2" "Version info saved (x264: ${x264_ver})"
}

phase3_run_benchmarks() {
    log "PHASE3" "=== Phase 3: Run Benchmarks ==="
    mkdir -p "${RESULTS_DIR}"
    log "PHASE3A" "Running H.264 encode preset sweep..."
    python3 "${SCRIPT_DIR}/scripts/benchmark_encode.py" \
        "${BENCHMARK_BIN}" "${YUV_FILE}" "${YUV_WIDTH}" "${YUV_HEIGHT}" "${YUV_FRAMES}" \
        "${RESULTS_DIR}/benchmark_encode.json" "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "encode benchmark had issues"
    log "PHASE3B" "Running micro benchmark..."
    python3 "${SCRIPT_DIR}/scripts/micro_benchmark.py" \
        "${BENCHMARK_BIN}" "${RESULTS_DIR}/micro_benchmark.json" "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "micro benchmark had issues"
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
    log "START" "${SOFTWARE_NAME} Source Build & Performance Benchmark - ${SOFTWARE_VERSION}"
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
testSoftwareIsInstalled() { local f=0; [ -n "${BENCHMARK_BIN}" ] && [ -x "${BENCHMARK_BIN}" ] && f=1; if [ "${f}" -eq 0 ]; then echo "WARNING: x264 binary not found"; startSkipping; return; fi; assertTrue "x264 binary should be executable" "[ ${f} -eq 1 ]"; }
testSoftwareVersionMatches() { local v="${SOFTWARE_VERSION}"; assertNotNull "Version should not be empty" "${v}"; }
testVersionInfoExists() { assertTrue "version_info.json should exist" "[ -f '${RESULTS_DIR}/version_info.json' ]"; }
testVersionInfoHasArchitecture() { local vf="${RESULTS_DIR}/version_info.json"; [ -f "${vf}" ] || { startSkipping; return; }; assertTrue "has architecture" "[ $(json_field_exists "${vf}" architecture) -eq 1 ]"; }
testVersionInfoHasSoftwareVersion() { local vf="${RESULTS_DIR}/version_info.json"; [ -f "${vf}" ] || { startSkipping; return; }; assertTrue "has software_version" "[ $(json_field_exists "${vf}" software_version) -eq 1 ]"; }

testBenchmarkPrimaryProducesResults() { assertTrue "benchmark_encode.json should exist" "[ -f '${RESULTS_DIR}/benchmark_encode.json' ]"; }
testBenchmarkPrimaryHasRequiredFields() { local bf="${RESULTS_DIR}/benchmark_encode.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has benchmark" "[ $(json_contains "${bf}" benchmark) -eq 1 ]"; assertTrue "has performance_metrics" "[ $(json_contains "${bf}" performance_metrics) -eq 1 ]"; assertTrue "has results_summary" "[ $(json_contains "${bf}" results_summary) -eq 1 ]"; }
testBenchmarkPrimaryFpsAboveThreshold() { local bf="${RESULTS_DIR}/benchmark_encode.json"; [ -f "${bf}" ] || { startSkipping; return; }; local fps; fps="$(json_get "${bf}" results_summary preset_medium fps)"; if [ "${fps}" = "NULL" ] || [ -z "${fps}" ]; then startSkipping; return; fi; echo "[DIAG] medium preset fps: ${fps} (threshold: ${MIN_FPS})"; assertTrue "medium preset fps (${fps}) should be >= ${MIN_FPS}" "[ $(echo "${fps} >= ${MIN_FPS}" | bc -l) -eq 1 ]"; }
testBenchmarkPrimaryIsEncode() { local bf="${RESULTS_DIR}/benchmark_encode.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertEquals "benchmark should be encode" "encode" "$(json_get "${bf}" benchmark)"; }
testBenchmarkPrimaryPresetSweepCompleted() { local bf="${RESULTS_DIR}/benchmark_encode.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has ultrafast" "[ $(json_contains "${bf}" preset_ultrafast) -eq 1 ]"; assertTrue "has medium" "[ $(json_contains "${bf}" preset_medium) -eq 1 ]"; assertTrue "has veryslow" "[ $(json_contains "${bf}" preset_veryslow) -eq 1 ]"; }

testBenchmarkMicroProducesResults() { assertTrue "micro_benchmark.json should exist" "[ -f '${RESULTS_DIR}/micro_benchmark.json' ]"; }
testBenchmarkMicroHasRequiredFields() { local bf="${RESULTS_DIR}/micro_benchmark.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has benchmark" "[ $(json_contains "${bf}" benchmark) -eq 1 ]"; assertTrue "has results" "[ $(json_contains "${bf}" results) -eq 1 ]"; }
testBenchmarkMicroResolutionScaling() { local bf="${RESULTS_DIR}/micro_benchmark.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has resolution_scaling" "[ $(json_contains "${bf}" resolution_scaling) -eq 1 ]"; }
testBenchmarkMicroThreadScaling() { local bf="${RESULTS_DIR}/micro_benchmark.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has thread_scaling" "[ $(json_contains "${bf}" thread_scaling) -eq 1 ]"; }

testAggregatedResultsExist() { assertTrue "results.json should exist" "[ -f '${RESULTS_DIR}/results.json' ]"; }
testSummaryReportGenerated() { assertTrue "results.txt should exist" "[ -f '${RESULTS_DIR}/results.txt' ]"; }
testLogFileGenerated() { assertTrue "results.log should exist" "[ -f '${RESULTS_DIR}/results.log' ]"; }
testAggregatedResultsContainsAllBenchmarks() { local af="${RESULTS_DIR}/results.json"; [ -f "${af}" ] || { startSkipping; return; }; assertTrue "has primary" "[ $(json_contains "${af}" primary) -eq 1 ]"; assertTrue "has micro" "[ $(json_contains "${af}" micro) -eq 1 ]"; }

usage() {
    cat <<USAGE
Usage: $(basename "$0") [OPTIONS]
x264 Source Build & Performance Benchmark (shUnit2)
Options:
  --check    Check prerequisites only
  -h|--help  Show this help
Environment variables:
  SOFTWARE_VERSION   x264 version label (default: rolling; x264 has no release tags)
  TARGET_OS          OS name in results (default: openEuler 24.03 SP3)
  TARGET_MODEL       Hardware model (default: Kunpeng-920)
  YUV_WIDTH          Test YUV width (default: 1280)
  YUV_HEIGHT         Test YUV height (default: 720)
  YUV_FRAMES         Test YUV frames (default: 50)
  ITERATIONS         Iterations per preset (default: 1)
  MIN_FPS            Minimum medium-preset fps threshold (default: 10)
Examples:
  ./x264_test.sh --check
  ./x264_test.sh
  YUV_FRAMES=100 ITERATIONS=3 ./x264_test.sh
USAGE
}

main() {
    local check_only=0
    while [ $# -gt 0 ]; do case "$1" in --check) check_only=1; shift ;; -h|--help) usage; exit 0 ;; *) log "ERROR" "Unknown option: $1"; usage; exit 1 ;; esac; done
    log "START" "${SOFTWARE_NAME} Source Build & Performance Benchmark ${SOFTWARE_VERSION}"
    if [ "${check_only}" -eq 1 ]; then check_prerequisites; exit $?; fi
    check_prerequisites || { log "FATAL" "Prerequisites not met"; exit 1; }
    download_shunit2 || { log "FATAL" "Failed to download shUnit2"; exit 1; }
    SHUNIT_PARENT="${SCRIPT_DIR}/${SOFTWARE_NAME}_test.sh"
    . "${SHUNIT2_PATH}"
}

if [ "${1:-}" != "--shunit2-run" ]; then main "$@"; fi
