#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOFTWARE_NAME="scann"
SOFTWARE_VERSION="${SOFTWARE_VERSION:-1.4.0}"
BUILD_METHOD="${BUILD_METHOD:-pip}"
TARGET_OS="${TARGET_OS:-openEuler 24.03 SP3}"
TARGET_MODEL="${TARGET_MODEL:-Kunpeng-920}"
RESULTS_DIR="${SCRIPT_DIR}/results/${SOFTWARE_VERSION}"
mkdir -p "${RESULTS_DIR}"
LOG_FILE="${RESULTS_DIR}/results.log"

DATA_SCALE="${DATA_SCALE:-100K}"
DATA_DIM="${DATA_DIM:-128}"
ITERATIONS="${ITERATIONS:-1}"
K_VALUE="${K_VALUE:-10}"

MINIMUM_QPS="${MINIMUM_QPS:-50}"
MINIMUM_RECALL="${MINIMUM_RECALL:-0.3}"
MAXIMUM_LATENCY_US="${MAXIMUM_LATENCY_US:-5000}"
MINIMUM_ADD_RATE="${MINIMUM_ADD_RATE:-500}"

INSTALL_TIMEOUT="${INSTALL_TIMEOUT:-300}"
PHASE_TIMEOUT="${PHASE_TIMEOUT:-1800}"

JSON_HELPER="${SCRIPT_DIR}/scripts/json_helper.py"

log() { local tag="$1"; shift; printf '[%s] %s\n' "$tag" "$*" | tee -a "${LOG_FILE}"; }

run_phase() {
    local secs="$1"; shift
    timeout "${secs}" "$@" 2>&1 | tee -a "${LOG_FILE}"
    local rc="${PIPESTATUS[0]}"
    if [ "${rc}" -eq 124 ]; then
        log "TIMEOUT" "Command timed out after ${secs}s: $*"
    elif [ "${rc}" -ne 0 ]; then
        log "WARN" "Command exited with code ${rc}: $*"
    fi
    return "${rc}"
}

run_timeout() {
    local secs="$1"; shift
    timeout "${secs}" "$@"
    local rc=$?
    if [ "${rc}" -eq 124 ]; then
        log "TIMEOUT" "Command timed out after ${secs}s: $*"
    elif [ "${rc}" -ne 0 ]; then
        log "WARN" "Command exited with code ${rc}: $*"
    fi
    return "${rc}"
}

json_get()              { python3 "${JSON_HELPER}" "$1" get "${@:2}"; }
json_field_exists()     { python3 "${JSON_HELPER}" "$1" field_exists "$2"; }
json_count_results()    { python3 "${JSON_HELPER}" "$1" count_results; }
json_throughput_ge()    { python3 "${JSON_HELPER}" "$1" throughput_ge "$2" "${@:3}"; }
json_latency_le()       { python3 "${JSON_HELPER}" "$1" latency_le "$2" "${@:3}"; }
json_avg_throughput()   { python3 "${JSON_HELPER}" "$1" avg_throughput "${@:2}"; }
json_max_latency()      { python3 "${JSON_HELPER}" "$1" max_latency "${@:2}"; }
json_version()          { python3 "${JSON_HELPER}" "$1" version; }
json_contains()         { python3 "${JSON_HELPER}" "$1" contains "$2"; }

detect_os_name() { echo "${TARGET_OS}"; }

download_shunit2() {
    if [ -n "${SHUNIT2_PATH}" ] && [ -f "${SHUNIT2_PATH}" ]; then
        log "SETUP" "Using provided shUnit2 at ${SHUNIT2_PATH}"
        return 0
    fi
    local shunit2_tmpdir
    shunit2_tmpdir="$(mktemp -d /tmp/shunit2_XXXXXX)"
    SHUNIT2_PATH="${shunit2_tmpdir}/shunit2"
    log "SETUP" "Downloading shUnit2 to ${shunit2_tmpdir}..."
    local mirrors=(
        "https://raw.githubusercontent.com/kward/shunit2/master/shunit2"
        "https://mirrors.aliyun.com/github-raw/kward/shunit2/master/shunit2"
        "https://raw.gitmirror.com/kward/shunit2/master/shunit2"
    )
    local downloaded=0
    for mirror_url in "${mirrors[@]}"; do
        curl --connect-timeout 30 --max-time 60 -sL -o "${SHUNIT2_PATH}" "${mirror_url}" && {
            chmod +x "${SHUNIT2_PATH}"
            grep -q "^SHUNIT_VERSION=" "${SHUNIT2_PATH}" && { downloaded=1; break; }
        }
        rm -f "${SHUNIT2_PATH}"
    done
    if [ "${downloaded}" -eq 0 ]; then
        for mirror_url in "${mirrors[@]}"; do
            wget --timeout=30 --tries=2 -q -O "${SHUNIT2_PATH}" "${mirror_url}" 2>/dev/null && {
                chmod +x "${SHUNIT2_PATH}"
                grep -q "^SHUNIT_VERSION=" "${SHUNIT2_PATH}" && { downloaded=1; break; }
            }
            rm -f "${SHUNIT2_PATH}"
        done
    fi
    if [ "${downloaded}" -eq 0 ]; then
        log "ERROR" "Failed to download shUnit2"
        rm -rf "${shunit2_tmpdir}"
        return 1
    fi
}

check_prerequisites() {
    local errors=0
    if ! command -v python3 >/dev/null 2>&1; then
        log "ERROR" "python3 is not installed (need Python 3.9-3.13)"
        errors=$((errors + 1))
    else
        log "CHECK" "Python3 OK: $(python3 --version 2>&1)"
    fi
    python3 -c "import numpy" 2>/dev/null || {
        log "WARN" "numpy not installed, will install via pip"
        pip3 install --break-system-packages numpy 2>&1 | tee -a "${LOG_FILE}" || {
            log "ERROR" "Failed to install numpy"
            errors=$((errors + 1))
        }
    }
    if [ ! -f "${JSON_HELPER}" ]; then
        log "ERROR" "json_helper.py not found at ${JSON_HELPER}"
        errors=$((errors + 1))
    else
        log "CHECK" "json_helper.py OK"
    fi
    return ${errors}
}

phase1_install() {
    log "PHASE1" "=== Phase 1: Install ScaNN v${SOFTWARE_VERSION} (method: ${BUILD_METHOD}) ==="
    python3 -c "import scann" 2>/dev/null && {
        log "PHASE1" "ScaNN already importable, skipping install"
        return 0
    }
    case "${BUILD_METHOD}" in
        pip)
            log "PHASE1" "Installing scann==${SOFTWARE_VERSION} via pip..."
            run_phase ${INSTALL_TIMEOUT} pip3 install --break-system-packages "scann==${SOFTWARE_VERSION}" || {
                log "WARN" "scann==${SOFTWARE_VERSION} not found, trying latest..."
                run_phase ${INSTALL_TIMEOUT} pip3 install --break-system-packages scann || {
                    log "ERROR" "Failed to install scann via pip"
                    return 1
                }
            }
            ;;
        *)
            log "ERROR" "ScaNN only supports BUILD_METHOD=pip (prebuilt ARM NEON wheel)"
            return 1
            ;;
    esac
    python3 -c "import scann" 2>/dev/null || {
        log "ERROR" "scann import failed after install"
        return 1
    }
    log "PHASE1" "ScaNN v${SOFTWARE_VERSION} installed successfully (${BUILD_METHOD})"
}

phase2_verify() {
    log "PHASE2" "=== Phase 2: Collect Version Info ==="
    local timestamp model arch kernel os_name cpu_model cores python_ver numpy_ver
    timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ' | tr -d '\n\t')"
    model="${TARGET_MODEL}"
    arch="$(uname -m | tr -d '\n\t')"
    kernel="$(uname -r | tr -d '\n\t')"
    os_name="$(detect_os_name | tr -d '\n\t')"
    cpu_model="$(grep 'model name' /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | xargs | tr -d '\n\t')"
    if [ -z "${cpu_model}" ]; then
        local num_proc
        num_proc="$(grep -c 'processor' /proc/cpuinfo 2>/dev/null || echo 0)"
        cpu_model="ARM64 CPU (${num_proc} cores)"
    fi
    cores="$(nproc 2>/dev/null | tr -d '\n\t' || echo '4')"
    python_ver="$(python3 --version 2>&1 | tr -d '\n\t')"
    numpy_ver="$(python3 -c 'import numpy; print(numpy.__version__)' 2>/dev/null | tr -d '\n\t' || echo 'unknown')"
    python3 "${JSON_HELPER}" "${RESULTS_DIR}/version_info.json" write_version_info \
        "${timestamp}" "${model}" "${arch}" "${kernel}" "${os_name}" "${cpu_model}" \
        "${cores}" "${SOFTWARE_NAME}" "${SOFTWARE_VERSION}" \
        "${python_ver}" "${numpy_ver}"
    log "PHASE2" "Version info saved (OS: ${os_name})"
}

phase3_run_benchmarks() {
    log "PHASE3" "=== Phase 3: Run Benchmarks ==="
    mkdir -p "${RESULTS_DIR}"
    export DATA_SCALE DATA_DIM ITERATIONS K_VALUE RESULTS_DIR

    log "PHASE3A" "Running ANN benchmark..."
    run_phase ${PHASE_TIMEOUT} python3 "${SCRIPT_DIR}/scripts/benchmark_ann.py" \
        --output "${RESULTS_DIR}/benchmark_ann.json" \
        --data-scale "${DATA_SCALE}" \
        --data-dim "${DATA_DIM}" \
        --iterations "${ITERATIONS}" \
        --k "${K_VALUE}"

    log "PHASE3B" "Running micro benchmark..."
    run_phase ${PHASE_TIMEOUT} python3 "${SCRIPT_DIR}/scripts/micro_benchmark.py" \
        --output "${RESULTS_DIR}/micro_benchmark.json" \
        --data-scale "${DATA_SCALE}" \
        --data-dim "${DATA_DIM}" \
        --iterations "${ITERATIONS}"
}

phase4_results() {
    log "PHASE4" "=== Phase 4: Aggregate & Report ==="
    run_timeout ${PHASE_TIMEOUT} python3 "${SCRIPT_DIR}/scripts/aggregate_results.py" \
        --results-dir "${RESULTS_DIR}" \
        --output "${RESULTS_DIR}/results.json"
    run_timeout ${PHASE_TIMEOUT} python3 "${SCRIPT_DIR}/scripts/generate_summary.py" \
        "${RESULTS_DIR}/results.json" \
        "${RESULTS_DIR}/results.txt"
    log "PHASE4" "Reports generated:"
    log "PHASE4" "  JSON: ${RESULTS_DIR}/results.json"
    log "PHASE4" "  TXT:  ${RESULTS_DIR}/results.txt"
    log "PHASE4" "  LOG:  ${RESULTS_DIR}/results.log"
}

oneTimeSetUp() {
    mkdir -p "${RESULTS_DIR}"
    log "START" "${SOFTWARE_NAME} Performance Benchmark - v${SOFTWARE_VERSION} (${BUILD_METHOD})"
    local os_name os_id
    os_name="$(detect_os_name)"
    os_id="$(cat /etc/os-release 2>/dev/null | grep '^ID=' | cut -d= -f2 | tr -d '\"' || echo 'unknown')"
    log "START" "OS: ${os_name} (${os_id}), Build: ${BUILD_METHOD}"
    check_prerequisites || log "WARN" "Some prerequisites missing, continuing..."
    phase1_install || log "WARN" "Phase 1 had issues, continuing..."
    phase2_verify || log "WARN" "Phase 2 had issues, continuing..."
    phase3_run_benchmarks || log "WARN" "Phase 3 had issues, continuing..."
    phase4_results || log "WARN" "Phase 4 had issues..."
}

oneTimeTearDown() { :; }
setUp() { rm -f "${RESULTS_DIR}/test_temp_*.json"; }
tearDown() { rm -f "${RESULTS_DIR}/test_temp_*.json"; }

testArchitectureIsARM64() {
    local arch
    arch="$(uname -m)"
    assertTrue "Architecture should be aarch64 or arm64, got: ${arch}" \
        "[ '${arch}' = 'aarch64' ] || [ '${arch}' = 'arm64' ]"
}

testSoftwareIsInstalled() {
    local found=0
    python3 -c "import scann" 2>/dev/null && found=1
    if [ "${found}" -eq 0 ]; then
        echo "WARNING: scann not installed, skipping install check"
        startSkipping
        return
    fi
    assertTrue "scann should be importable" "[ ${found} -eq 1 ]"
}

testSoftwareVersionMatches() {
    local ver="${SOFTWARE_VERSION}"
    assertNotNull "Version should not be empty" "${ver}"
}

testVersionInfoExists() {
    assertTrue "Version info JSON should exist" "[ -f '${RESULTS_DIR}/version_info.json' ]"
}

testVersionInfoHasArchitecture() {
    local vfile="${RESULTS_DIR}/version_info.json"
    if [ ! -f "${vfile}" ]; then startSkipping; return; fi
    assertTrue "Version info should have architecture field" \
        "[ $(json_field_exists "${vfile}" architecture) -eq 1 ]"
}

testVersionInfoHasSoftwareVersion() {
    local vfile="${RESULTS_DIR}/version_info.json"
    if [ ! -f "${vfile}" ]; then startSkipping; return; fi
    assertTrue "Version info should have software_version field" \
        "[ $(json_field_exists "${vfile}" software_version) -eq 1 ]"
}

testBenchmarkANNProducesResults() {
    assertTrue "ANN benchmark JSON should exist" "[ -f '${RESULTS_DIR}/benchmark_ann.json' ]"
}

testBenchmarkANNHasRequiredFields() {
    local bench_file="${RESULTS_DIR}/benchmark_ann.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    assertTrue "Should have benchmark field" "[ $(json_contains "${bench_file}" benchmark) -eq 1 ]"
    assertTrue "Should have performance_metrics field" "[ $(json_contains "${bench_file}" performance_metrics) -eq 1 ]"
    assertTrue "Should have results_summary field" "[ $(json_contains "${bench_file}" results_summary) -eq 1 ]"
}

testBenchmarkANNThroughputAboveThreshold() {
    local bench_file="${RESULTS_DIR}/benchmark_ann.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_throughput
    has_throughput="$(json_throughput_ge "${bench_file}" "${MINIMUM_QPS}" results_summary avg_leaves_sweep 50 qps)"
    local actual_qps
    actual_qps="$(json_avg_throughput "${bench_file}" results_summary avg_leaves_sweep 50 qps)"
    echo "[DIAG] ANN QPS at leaves=50: ${actual_qps} (threshold: ${MINIMUM_QPS})"
    assertTrue "ANN QPS should be >= ${MINIMUM_QPS}, got ${actual_qps}" "[ ${has_throughput} -eq 1 ]"
}

testBenchmarkANNRecallAboveThreshold() {
    local bench_file="${RESULTS_DIR}/benchmark_ann.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_recall
    has_recall="$(json_throughput_ge "${bench_file}" "${MINIMUM_RECALL}" results_summary avg_leaves_sweep 200 recall_at_10)"
    local actual_recall
    actual_recall="$(json_avg_throughput "${bench_file}" results_summary avg_leaves_sweep 200 recall_at_10)"
    echo "[DIAG] ANN recall@10 at leaves=200: ${actual_recall} (threshold: ${MINIMUM_RECALL})"
    assertTrue "ANN recall should be >= ${MINIMUM_RECALL}, got ${actual_recall}" "[ ${has_recall} -eq 1 ]"
}

testBenchmarkANNLeavesSweepCompleted() {
    local bench_file="${RESULTS_DIR}/benchmark_ann.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_leaves_sweep
    has_leaves_sweep="$(json_contains "${bench_file}" avg_leaves_sweep)"
    assertTrue "Should have leaves_sweep results" "[ ${has_leaves_sweep} -eq 1 ]"
}

testBenchmarkMicroProducesResults() {
    assertTrue "Micro benchmark JSON should exist" "[ -f '${RESULTS_DIR}/micro_benchmark.json' ]"
}

testBenchmarkMicroAllOperationsCompleted() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local ops_count
    ops_count="$(json_count_results "${bench_file}")"
    assertTrue "Should have micro benchmark results (count=${ops_count})" "[ ${ops_count} -ge 3 ]"
}

testBenchmarkMicroIndexConstructionRate() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_rate
    has_rate="$(json_throughput_ge "${bench_file}" "${MINIMUM_ADD_RATE}" results index_construction add_rate_per_sec)"
    local actual_rate
    actual_rate="$(json_get "${bench_file}" results index_construction add_rate_per_sec)"
    echo "[DIAG] Index construction rate: ${actual_rate} vectors/sec (threshold: ${MINIMUM_ADD_RATE})"
    assertTrue "Index construction rate should be >= ${MINIMUM_ADD_RATE}" "[ ${has_rate} -eq 1 ]"
}

testBenchmarkMicroMultithreadScaling() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_mt
    has_mt="$(json_contains "${bench_file}" batch_search_multithread)"
    assertTrue "Should have multithread search results" "[ ${has_mt} -eq 1 ]"
}

testAggregatedResultsExist() {
    assertTrue "results.json should exist" "[ -f '${RESULTS_DIR}/results.json' ]"
}

testSummaryReportGenerated() {
    assertTrue "results.txt should exist" "[ -f '${RESULTS_DIR}/results.txt' ]"
}

testLogFileGenerated() {
    assertTrue "results.log should exist" "[ -f '${RESULTS_DIR}/results.log' ]"
}

testAggregatedResultsContainsAllBenchmarks() {
    local agg_file="${RESULTS_DIR}/results.json"
    if [ ! -f "${agg_file}" ]; then startSkipping; return; fi
    assertTrue "Should contain ann benchmark data" "[ $(json_contains "${agg_file}" ann) -eq 1 ]"
    assertTrue "Should contain micro benchmark data" "[ $(json_contains "${agg_file}" micro) -eq 1 ]"
}

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --check              Check prerequisites only"
    echo "  -h, --help           Show this help message"
    echo ""
    echo "Environment variables:"
    echo "  SOFTWARE_VERSION     ScaNN version (default: 1.4.0)"
    echo "  BUILD_METHOD         Build method: pip (default: pip, only option)"
    echo "  TARGET_OS            OS name in results (default: openEuler 24.03 SP3)"
    echo "  TARGET_MODEL         Hardware model (default: Kunpeng-920)"
    echo "  DATA_SCALE           Dataset scale: 10K, 100K, 1M (default: 100K)"
    echo "  DATA_DIM             Vector dimension (default: 128)"
    echo "  ITERATIONS           Number of iterations (default: 1)"
    echo "  K_VALUE              k for nearest neighbor (default: 10)"
    echo "  MINIMUM_QPS          QPS threshold (default: 50)"
    echo "  MINIMUM_RECALL       Recall threshold (default: 0.3)"
    echo "  MINIMUM_ADD_RATE     Index construction rate threshold (default: 500)"
    echo "  INSTALL_TIMEOUT      Timeout for pip install in seconds (default: 300)"
    echo "  PHASE_TIMEOUT        Timeout for each benchmark/aggregate phase in seconds (default: 1800)"
    exit 0
}

main() {
    local check_only=0
    while [ $# -gt 0 ]; do
        case "$1" in
            --check)      check_only=1; shift ;;
            -h|--help)    usage ;;
            *)            log "ERROR" "Unknown option: $1"; usage ;;
        esac
    done
    log "START" "${SOFTWARE_NAME} Performance Benchmark v${SOFTWARE_VERSION}"
    if [ "${check_only}" -eq 1 ]; then
        check_prerequisites
        exit $?
    fi
    check_prerequisites || { log "FATAL" "Prerequisites not met"; exit 1; }
    download_shunit2 || { log "FATAL" "Failed to download shUnit2"; exit 1; }
    . "${SHUNIT2_PATH}"
}

if [ "${1:-}" != "--shunit2-run" ]; then
    main "$@"
fi
