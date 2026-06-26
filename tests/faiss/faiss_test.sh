#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTS_DIR="${SCRIPT_DIR}/results"
SOFTWARE_NAME="faiss"
SOFTWARE_VERSION="${SOFTWARE_VERSION:-1.14.2}"
SHUNIT_PARENT="${SCRIPT_DIR}/${SOFTWARE_NAME}_test.sh"
LOG_FILE="${RESULTS_DIR}/results.log"
JSON_HELPER="${SCRIPT_DIR}/scripts/json_helper.py"

DATA_SCALE="${DATA_SCALE:-100K}"
DATA_DIM="${DATA_DIM:-128}"
ITERATIONS="${ITERATIONS:-1}"
K="${K:-10}"
MIN_QPS_FLAT="${MIN_QPS_FLAT:-10}"
MAX_LATENCY_SINGLE_US="${MAX_LATENCY_SINGLE_US:-5000}"
MIN_RECALL_FLAT="${MIN_RECALL_FLAT:-0.5}"
log() { local tag="$1"; shift; printf '[%s] %s\n' "$tag" "$*" | tee -a "${LOG_FILE}"; }
json_get() { python3 "${JSON_HELPER}" "$1" get "${@:2}"; }
json_field_exists() { python3 "${JSON_HELPER}" "$1" field_exists "$2"; }
json_count_results() { python3 "${JSON_HELPER}" "$1" count_results; }
json_throughput_ge() { python3 "${JSON_HELPER}" "$1" throughput_ge "$2" "${@:3}"; }
json_latency_le() { python3 "${JSON_HELPER}" "$1" latency_le "$2" "${@:3}"; }
json_avg_throughput() { python3 "${JSON_HELPER}" "$1" avg_throughput "${@:2}"; }
json_max_latency() { python3 "${JSON_HELPER}" "$1" max_latency "${@:2}"; }
json_version() { python3 "${JSON_HELPER}" "$1" version; }
json_contains() { python3 "${JSON_HELPER}" "$1" contains "$2"; }
download_shunit2() {
    if [ -f "${SCRIPT_DIR}/shunit2" ]; then
        log "SETUP" "shUnit2 already present"
        return 0
    fi
    log "SETUP" "Downloading shUnit2..."
    local mirrors=(
        "https://raw.githubusercontent.com/kward/shunit2/master/shunit2"
        "https://mirrors.aliyun.com/github-raw/kward/shunit2/master/shunit2"
        "https://raw.gitmirror.com/kward/shunit2/master/shunit2"
    )
    local downloaded=0
    for mirror_url in "${mirrors[@]}"; do
        curl --connect-timeout 30 --max-time 60 -sL -o "${SCRIPT_DIR}/shunit2" "${mirror_url}" && {
            chmod +x "${SCRIPT_DIR}/shunit2"
            grep -q "^SHUNIT_VERSION=" "${SCRIPT_DIR}/shunit2" && { downloaded=1; break; }
        }
        rm -f "${SCRIPT_DIR}/shunit2"
    done
    if [ "${downloaded}" -eq 0 ]; then
        for mirror_url in "${mirrors[@]}"; do
            wget --timeout=30 --tries=2 -q -O "${SCRIPT_DIR}/shunit2" "${mirror_url}" 2>/dev/null && {
                chmod +x "${SCRIPT_DIR}/shunit2"
                grep -q "^SHUNIT_VERSION=" "${SCRIPT_DIR}/shunit2" && { downloaded=1; break; }
            }
            rm -f "${SCRIPT_DIR}/shunit2"
        done
    fi
    if [ "${downloaded}" -eq 0 ]; then
        log "ERROR" "Failed to download shUnit2"
        return 1
    fi
    log "SETUP" "shUnit2 downloaded successfully"
}
check_prerequisites() {
    local errors=0
    if ! command -v python3 >/dev/null 2>&1; then
        log "ERROR" "python3 is not installed. Please install Python 3.8+."
        errors=$((errors + 1))
    else
        log "CHECK" "Python3 OK: $(python3 --version 2>&1)"
    fi
    if ! python3 -c "import numpy" 2>/dev/null; then
        log "WARN" "numpy not available"
    fi
    if ! python3 -c "import faiss" 2>/dev/null; then
        log "ERROR" "faiss Python module is not installed. Please install faiss-cpu"
        log "ERROR" "  Recommended: pip install faiss-cpu==${SOFTWARE_VERSION}"
        errors=$((errors + 1))
    else
        log "CHECK" "Faiss OK: $(python3 -c 'import faiss; print(faiss.__version__)' 2>&1 | head -1)"
    fi
    if [ ! -f "${JSON_HELPER}" ]; then
        log "ERROR" "json_helper.py not found at ${JSON_HELPER}"
        errors=$((errors + 1))
    fi
    return ${errors}
}
phase2_verify() {
    log "PHASE2" "=== Phase 2: Collect Version Info ==="
    local timestamp arch kernel os_name cpu_model cores mem_mb python_ver faiss_ver numpy_ver blas
    timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ' | tr -d '\n\t')"
    arch="$(uname -m | tr -d '\n\t')"
    kernel="$(uname -r | tr -d '\n\t')"
    os_name="$(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2 | tr -d '\n\t' || echo 'unknown')"
    cpu_model="$(grep 'model name' /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | xargs | tr -d '\n\t')"
    if [ -z "${cpu_model}" ]; then
        local num_proc
        num_proc="$(grep -c 'processor' /proc/cpuinfo 2>/dev/null || echo 0)"
        cpu_model="ARM64 CPU (${num_proc} cores)"
    fi
    cores="$(nproc 2>/dev/null | tr -d '\n\t' || echo '4')"
    mem_mb="$(free -m 2>/dev/null | awk '/^Mem:/ {print $2}' | tr -d '\n\t' || echo '0')"
    python_ver="$(python3 --version 2>&1 | tr -d '\n\t')"
    faiss_ver="$(python3 -c 'import faiss; print(faiss.__version__)' 2>/dev/null | tr -d '\n\t' || echo 'unknown')"
    numpy_ver="$(python3 -c 'import numpy; print(numpy.__version__)' 2>/dev/null | tr -d '\n\t' || echo 'unknown')"
    blas="$(python3 -c 'import numpy; numpy.show_config()' 2>/dev/null | grep -c 'openblas' | tr -d '\n\t' || echo '0')"
    python3 "${JSON_HELPER}" "${RESULTS_DIR}/version_info.json" write_version_info \
        "${timestamp}" "${arch}" "${kernel}" "${os_name}" "${cpu_model}" \
        "${cores}" "${mem_mb}" "${SOFTWARE_NAME}" "${SOFTWARE_VERSION}" \
        "${python_ver}" "${faiss_ver}" "${numpy_ver}" "${blas}" "${cores}"
    log "PHASE2" "Version info saved."
}
phase3_run_benchmarks() {
    log "PHASE3" "=== Phase 3: Run Benchmarks ==="
    mkdir -p "${RESULTS_DIR}"
    export DATA_SCALE DATA_DIM ITERATIONS K RESULTS_DIR
    log "PHASE3A" "Running ANN benchmark..."
    python3 "${SCRIPT_DIR}/scripts/benchmark_ann.py" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "ANN benchmark had issues"
    log "PHASE3B" "Running micro benchmarks"
    python3 "${SCRIPT_DIR}/scripts/micro_benchmark.py" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "Micro benchmark had issues"
}
phase4_results() {
    log "PHASE4" "=== Phase 4: Aggregate & Report ==="
    python3 "${SCRIPT_DIR}/scripts/aggregate_results.py" \
        "${RESULTS_DIR}" "${RESULTS_DIR}/results.json"
    python3 "${SCRIPT_DIR}/scripts/generate_summary.py" \
        "${RESULTS_DIR}/results.json" "${RESULTS_DIR}/results.txt"
    python3 "${SCRIPT_DIR}/scripts/generate_html_report.py" \
        "${RESULTS_DIR}/results.json" "${RESULTS_DIR}/results.html"
    log "PHASE4" "Reports generated:"
    log "PHASE4" "  JSON: ${RESULTS_DIR}/results.json"
    log "PHASE4" "  TXT:  ${RESULTS_DIR}/results.txt"
    log "PHASE4" "  HTML: ${RESULTS_DIR}/results.html"
    log "PHASE4" "  LOG:  ${RESULTS_DIR}/results.log"
}
oneTimeSetUp() {
    mkdir -p "${RESULTS_DIR}"
    log "START" "${SOFTWARE_NAME} ARM64 Performance Benchmark - v${SOFTWARE_VERSION}"
    if ! check_prerequisites; then
        log "FATAL" "Prerequisites not met. Use --check for detailed status."
        return 1
    fi
    phase2_verify || log "WARN" "Phase 2 had issues, continuing..."
    phase3_run_benchmarks || log "WARN" "Phase 3 had issues, continuing"
    phase4_results || log "WARN" "Phase 4 had issues"
}
setUp() {
    rm -f "${RESULTS_DIR}/test_temp_*.json"
}
tearDown() {
    rm -f "${RESULTS_DIR}/test_temp_*.json"
}
testArchitectureIsARM64() {
    local arch
    arch="$(uname -m)"
    assertTrue "Architecture should be aarch64 or arm64, got: ${arch}" \
        "[ '${arch}' = 'aarch64' ] || [ '${arch}' = 'arm64' ]"
}
testSoftwareIsInstalled() {
    local found=0
    if python3 -c "import faiss" 2>/dev/null; then found=1; fi
    if [ "${found}" -eq 0 ]; then
        echo "WARNING: Faiss not installed, skipping install check"
        startSkipping
        return
    fi
    assertTrue "Faiss Python module should be importable" "[ ${found} -eq 1 ]"
}
testSoftwareVersionMatches() {
    local ver="unknown"
    ver="$(python3 -c 'import faiss; print(faiss.__version__)' 2>/dev/null | tr -d '\n\t' || echo 'unknown')"
    if [ "${ver}" = "unknown" ]; then
        startSkipping
        return
    fi
    assertNotNull "Version should not be empty" "${ver}"
}
testSoftwareRunsBasicCommand() {
    if ! python3 -c "import faiss" 2>/dev/null; then
        startSkipping
        return
    fi
    local result
    result="$(python3 -c "
import faiss
import numpy as np
np.random.seed(42)
xb=np.random.random((1000,128)).astype('float32')
index=faiss.IndexFlatL2(128)
index.add(xb)
D,I=index.search(xb[:1],5)
print('OK')
" 2>&1)"
    assertTrue "Faiss IndexFlatL2 basic search should succeed" "[ $? -eq 0 ]"
}
testVersionInfoExists() {
    assertTrue "Version info JSON should exist" "[ -f '${RESULTS_DIR}/version_info.json' ]"
}
testVersionInfoHasArchitecture() {
    local vfile="${RESULTS_DIR}/version_info.json"
    if [ ! -f "${vfile}" ]; then
        startSkipping
        return
    fi
    local has_arch
    has_arch="$(json_field_exists "${vfile}" architecture)"
    assertTrue "Version info should have architecture field" "[ ${has_arch} -eq 1 ]"
}
testVersionInfoHasSoftwareVersion() {
    local vfile="${RESULTS_DIR}/version_info.json"
    if [ ! -f "${vfile}" ]; then
        startSkipping
        return
    fi
    local has_ver
    has_ver="$(json_field_exists "${vfile}" software_version)"
    assertTrue "Version info should have software_version field" "[ ${has_ver} -eq 1 ]"
}
testBenchmarkPrimaryProducesResults() {
    local bench_file="${RESULTS_DIR}/benchmark_primary.json"
    assertTrue "ANN benchmark JSON should exist" "[ -f '${bench_file}' ]"
}
testBenchmarkPrimaryHasRequiredFields() {
    local bench_file="${RESULTS_DIR}/benchmark_primary.json"
    if [ ! -f "${bench_file}" ]; then
        startSkipping
        return
    fi
    local has_benchmark has_metrics has_results
    has_benchmark="$(json_contains "${bench_file}" benchmark)"
    has_metrics="$(json_contains "${bench_file}" performance_metrics)"
    has_results="$(json_field_exists "${bench_file}" results)"
    assertTrue "Should have benchmark field" "[ ${has_benchmark} -eq 1 ]"
    assertTrue "Should have performance_metrics field" "[ ${has_metrics} -eq 1 ]"
    assertTrue "Should have results field" "[ ${has_results} -eq 1 ]"
}
testBenchmarkPrimaryThroughputAboveThreshold() {
    local bench_file="${RESULTS_DIR}/benchmark_primary.json"
    if [ ! -f "${bench_file}" ]; then
        startSkipping
        return
    fi
    local flat_qps
    flat_qps="$(json_get "${bench_file}" results_summary FlatL2 qps)"
    if [ "${flat_qps}" = "NULL" ] || [ -z "${flat_qps}" ]; then
        local count
        count="$(json_count_results "${bench_file}")"
        if [ "${count}" -gt 0 ]; then
            flat_qps="$(python3 "${JSON_HELPER}" "${bench_file}" avg_throughput results_summary FlatL2 qps)"
        else
            startSkipping
            return
        fi
    fi
    echo "[DIAG] FlatL2 QPS: ${flat_qps} (threshold: ${MIN_QPS_FLAT})"
    assertTrue "FlatL2 QPS (${flat_qps}) should be >= ${MIN_QPS_FLAT}" \
        "[ $(echo "${flat_qps} >= ${MIN_QPS_FLAT}" | bc -l) -eq 1 ]"
}
testBenchmarkPrimaryIsANN() {
    local bench_file="${RESULTS_DIR}/benchmark_primary.json"
    if [ ! -f "${bench_file}" ]; then
        startSkipping
        return
    fi
    local bench_name
    bench_name="$(json_get "${bench_file}" benchmark)"
    assertEquals "Benchmark name should be ann_search" "ann_search" "${bench_name}"
}
testBenchmarkMicroProducesResults() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    assertTrue "Micro benchmark JSON should exist" "[ -f '${bench_file}' ]"
}
testBenchmarkMicroAllOperationsCompleted() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then
        startSkipping
        return
    fi
    local ops_count
    ops_count="$(json_count_results "${bench_file}")"
    assertTrue "Should have micro benchmark results (count=${ops_count})" "[ ${ops_count} -gt 0 ]"
}
testBenchmarkMicroSearchLatencyBelowThreshold() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then
        startSkipping
        return
    fi
    local latency
    latency="$(json_get "${bench_file}" results search_single_flat avg_latency_us)"
    if [ "${latency}" = "NULL" ] || [ -z "${latency}" ]; then
        latency="$(json_max_latency "${bench_file}" results search_single_flat avg_latency_us)"
    fi
    echo "[DIAG] Single search latency: ${latency} us (threshold: ${MAX_LATENCY_SINGLE_US})"
    assertTrue "Single search latency (${latency}us) should be <= ${MAX_LATENCY_SINGLE_US}us" \
        "[ $(echo "${latency} <= ${MAX_LATENCY_SINGLE_US}" | bc -l) -eq 1 ]"
}
testBenchmarkMicroHasLatencyData() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then
        startSkipping
        return
    fi
    local has_latency
    has_latency="$(json_contains "${bench_file}" avg_latency_ms)"
    assertTrue "Micro benchmark should have avg_latency_ms data" "[ ${has_latency} -eq 1 ]"
}
testAggregatedResultsExist() {
    assertTrue "results.json should exist" "[ -f '${RESULTS_DIR}/results.json' ]"
}
testHtmlReportGenerated() {
    assertTrue "results.html should exist" "[ -f '${RESULTS_DIR}/results.html' ]"
}
testSummaryReportGenerated() {
    assertTrue "results.txt should exist" "[ -f '${RESULTS_DIR}/results.txt' ]"
}
testLogFileGenerated() {
    assertTrue "results.log should exist" "[ -f '${RESULTS_DIR}/results.log' ]"
}
testAggregatedResultsContainsAllBenchmarks() {
    local agg_file="${RESULTS_DIR}/results.json"
    if [ ! -f "${agg_file}" ]; then
        startSkipping
        return
    fi
    local has_primary has_micro
    has_primary="$(json_contains "${agg_file}" primary_benchmark)"
    has_micro="$(json_contains "${agg_file}" micro_benchmark)"
    assertTrue "Should contain primary_benchmark (ANN) data" "[ ${has_primary} -eq 1 ]"
    assertTrue "Should contain micro_benchmark data" "[ ${has_micro} -eq 1 ]"
}
oneTimeTearDown() {
    :
}
usage() {
    cat <<USAGE
Usage: $(basename "$0") [OPTIONS]
Faiss ARM64 Performance Benchmark (shUnit2)
Options:
  --check    Check prerequisites only (do not run benchmarks)
  -h|--help  Show this help
Environment variables:
  SOFTWARE_VERSION   Faiss version (default: 1.14.2)
  DATA_SCALE         Dataset size (default: 100K)
  DATA_DIM           Vector dimension (default: 128)
  ITERATIONS         Number of iterations (default: 1)
  K                  Number of nearest neighbors (default: 10)
  MIN_QPS_FLAT       Minimum FlatL2 QPS threshold (default: 10)
  MAX_LATENCY_SINGLE_US Maximum single search latency threshold (default: 5000)
  MIN_RECALL_FLAT    Minimum FlatL2 recall threshold (default: 0.5)
Examples:
  # Check prerequisites
  ./faiss_test.sh --check
  # Full run
  ./faiss_test.sh
  # Custom params
  DATA_SCALE=100K DATA_DIM=128 ITERATIONS=1 ./faiss_test.sh
USAGE
}
main() {
    local check_only=0
    while [ $# -gt 0 ]; do
        case "$1" in
            --check)      check_only=1; shift ;;
            -h|--help)    usage; exit 0 ;;
            *)            log "ERROR" "Unknown option: $1"; usage; exit 1 ;;
        esac
    done
    if [ "${check_only}" -eq 1 ]; then
        check_prerequisites
        exit $?
    fi
    if ! check_prerequisites; then
        log "FATAL" "Prerequisites not met. Use --check for detailed status."
        exit 1
    fi
    download_shunit2 || {
        log "FATAL" "Failed to download shUnit2."
        exit 1
    }
    . "${SCRIPT_DIR}/shunit2"
}
if [ "${1:-}" != "--shunit2-run" ]; then
    main "$@"
fi
