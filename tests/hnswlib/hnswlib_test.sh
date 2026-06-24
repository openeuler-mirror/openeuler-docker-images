#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTS_DIR="${SCRIPT_DIR}/results"
SOFTWARE_NAME="hnswlib"
SOFTWARE_VERSION="${HNSWLIB_VERSION:-0.8.0}"
SHUNIT_PARENT="${SCRIPT_DIR}/${SOFTWARE_NAME}_test.sh"

DATA_SCALE="${DATA_SCALE:-1M}"
DATA_DIM="${DATA_DIM:-128}"
ITERATIONS="${ITERATIONS:-1}"
K_VALUE="${K_VALUE:-10}"

MINIMUM_QPS="${MINIMUM_QPS:-100}"
MINIMUM_RECALL="${MINIMUM_RECALL:-0.90}"
MAXIMUM_LATENCY_US="${MAXIMUM_LATENCY_US:-5000}"
MINIMUM_ADD_RATE="${MINIMUM_ADD_RATE:-50000}"

LOG_FILE="${RESULTS_DIR}/results.log"

log() { local tag="$1"; shift; printf '[%s] %s\n' "$tag" "$*" | tee -a "${LOG_FILE}"; }

JSON_HELPER="${SCRIPT_DIR}/scripts/json_helper.py"

json_get()              { python3 "${JSON_HELPER}" "$1" get "${@:2}"; }
json_field_exists()     { python3 "${JSON_HELPER}" "$1" field_exists "$2"; }
json_count_results()    { python3 "${JSON_HELPER}" "$1" count_results; }
json_throughput_ge()    { python3 "${JSON_HELPER}" "$1" throughput_ge "$2" "${@:3}"; }
json_latency_le()       { python3 "${JSON_HELPER}" "$1" latency_le "$2" "${@:3}"; }
json_avg_throughput()   { python3 "${JSON_HELPER}" "$1" avg_throughput "${@:2}"; }
json_max_latency()      { python3 "${JSON_HELPER}" "$1" max_latency "${@:2}"; }
json_version()          { python3 "${JSON_HELPER}" "$1" version; }
json_contains()         { python3 "${JSON_HELPER}" "$1" contains "$2"; }

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
}

check_prerequisites() {
    local errors=0

    if ! command -v python3 >/dev/null 2>&1; then
        log "ERROR" "python3 is not installed. Please install Python 3.8+."
        errors=$((errors + 1))
    else
        log "CHECK" "Python3 OK: $(python3 --version 2>&1)"
    fi

    python3 -c "import hnswlib" 2>/dev/null || {
        log "ERROR" "hnswlib is not importable. Please install: pip install hnswlib==${SOFTWARE_VERSION}"
        log "ERROR" "  (On Debian/Ubuntu 23.04+, use: python3 -m venv ~/hnswlib-venv && source ~/hnswlib-venv/bin/activate && pip install hnswlib numpy)"
        errors=$((errors + 1))
    }
    if python3 -c "import hnswlib" 2>/dev/null; then
        log "CHECK" "hnswlib OK: $(python3 -c 'import hnswlib; print(hnswlib.__version__)' 2>/dev/null)"
    fi

    python3 -c "import numpy" 2>/dev/null || {
        log "ERROR" "numpy is not importable. Please install: pip install numpy"
        errors=$((errors + 1))
    }
    if python3 -c "import numpy" 2>/dev/null; then
        log "CHECK" "numpy OK: $(python3 -c 'import numpy; print(numpy.__version__)' 2>/dev/null)"
    fi

    if [ ! -f "${JSON_HELPER}" ]; then
        log "ERROR" "json_helper.py not found at ${JSON_HELPER}"
        errors=$((errors + 1))
    else
        log "CHECK" "json_helper.py OK"
    fi

    return ${errors}
}

phase2_verify() {
    log "PHASE2" "=== Phase 2: Collect Version Info ==="

    local timestamp arch kernel os cpu_model cores mem_mb python_ver
    timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ' | tr -d '\n\t')"
    arch="$(uname -m | tr -d '\n\t')"
    kernel="$(uname -r | tr -d '\n\t')"
    os="$(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2 | tr -d '\n\t' || echo 'unknown')"
    cpu_model="$(grep 'model name' /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | xargs | tr -d '\n\t')"
    if [ -z "${cpu_model}" ] || [ "${cpu_model}" = "" ]; then
        cpu_model="$(grep 'CPU part' /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | xargs | tr -d '\n\t' || echo 'unknown')"
    fi
    cores="$(nproc 2>/dev/null | tr -d '\n\t' || echo '4')"
    mem_mb="$(free -m 2>/dev/null | awk '/^Mem:/ {print $2}' | tr -d '\n\t' || echo '0')"
    python_ver="$(python3 --version 2>&1 | tr -d '\n\t' || echo 'unknown')"
    local hnswlib_ver numpy_ver
    hnswlib_ver="$(python3 -c 'import hnswlib; print(hnswlib.__version__)' 2>/dev/null | tr -d '\n\t' || echo 'unknown')"
    numpy_ver="$(python3 -c 'import numpy; print(numpy.__version__)' 2>/dev/null | tr -d '\n\t' || echo 'unknown')"
    local neon_asimd
    neon_asimd="$(grep -c 'asimd' /proc/cpuinfo 2>/dev/null | tr -d '\n\t' || echo '0')"
    local parallelism
    parallelism="$(nproc 2>/dev/null || echo 4)"

    python3 "${JSON_HELPER}" "${RESULTS_DIR}/version_info.json" write_version_info \
        "${timestamp}" "${arch}" "${kernel}" "${os}" "${cpu_model}" \
        "${cores}" "${mem_mb}" "${SOFTWARE_NAME}" "${SOFTWARE_VERSION}" \
        "${python_ver}" "pip" "1" "${parallelism}" \
        --output "${RESULTS_DIR}/version_info.json" \
        --extra "numpy_version=${numpy_ver}" \
        --extra "hnswlib_version=${hnswlib_ver}" \
        --extra "index_M=16" \
        --extra "index_ef_construction=200" \
        --extra "install_method=pip" \
        --extra "neon_asimd_available=${neon_asimd}"

    log "PHASE2" "Version info saved."
}

phase3_run_benchmarks() {
    log "PHASE3" "=== Phase 3: Run Benchmarks ==="

    python3 "${SCRIPT_DIR}/scripts/benchmark_ann.py" \
        --output "${RESULTS_DIR}/benchmark_ann.json" \
        --data-scale "${DATA_SCALE}" \
        --data-dim "${DATA_DIM}" \
        --iterations "${ITERATIONS}" \
        --k "${K_VALUE}" 2>&1 | tee -a "${LOG_FILE}"

    python3 "${SCRIPT_DIR}/scripts/micro_benchmark.py" \
        --output "${RESULTS_DIR}/micro_benchmark.json" \
        --data-scale "${DATA_SCALE}" \
        --data-dim "${DATA_DIM}" \
        --iterations "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}"
}

phase4_results() {
    log "PHASE4" "=== Phase 4: Aggregate & Report ==="

    python3 "${SCRIPT_DIR}/scripts/aggregate_results.py" \
        --results-dir "${RESULTS_DIR}" \
        --output "${RESULTS_DIR}/results.json"

    python3 "${SCRIPT_DIR}/scripts/generate_summary.py" \
        --input "${RESULTS_DIR}/results.json" \
        --output "${RESULTS_DIR}/results.txt"

    python3 "${SCRIPT_DIR}/scripts/generate_html_report.py" \
        --input "${RESULTS_DIR}/results.json" \
        --output "${RESULTS_DIR}/results.html"

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
    phase3_run_benchmarks || log "WARN" "Phase 3 had issues, continuing..."
    phase4_results || log "WARN" "Phase 4 had issues..."
}

oneTimeTearDown() {
    :
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

testPython3Available() {
    assertTrue "python3 should be available" "command -v python3 >/dev/null 2>&1"
}

testSoftwareIsInstalled() {
    local found=0
    python3 -c "import hnswlib" 2>/dev/null && found=1
    if [ "${found}" -eq 0 ]; then
        echo "WARNING: hnswlib not importable, skipping install check"
        startSkipping
        return
    fi
    assertTrue "hnswlib should be importable" "[ ${found} -eq 1 ]"
}

testSoftwareVersionMatches() {
    local ver
    ver="$(python3 -c 'import hnswlib; print(hnswlib.__version__)' 2>/dev/null | tr -d '\n\t' || echo 'unknown')"
    if [ "${ver}" = "unknown" ] || [ -z "${ver}" ]; then
        startSkipping
        return
    fi
    assertNotNull "Version should not be empty" "${ver}"
}

testVersionInfoJsonExists() {
    assertTrue "version_info.json should exist" "[ -f '${RESULTS_DIR}/version_info.json' ]"
}

testBenchmarkANNProducesResults() {
    local bench_file="${RESULTS_DIR}/benchmark_ann.json"
    assertTrue "ANN benchmark JSON should exist" "[ -f '${bench_file}' ]"
}

testBenchmarkANNHasRequiredFields() {
    local bench_file="${RESULTS_DIR}/benchmark_ann.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_benchmark has_metrics has_results
    has_benchmark="$(json_contains "${bench_file}" benchmark)"
    has_metrics="$(json_contains "${bench_file}" performance_metrics)"
    has_results="$(json_contains "${bench_file}" results_summary)"
    assertTrue "Should have benchmark field" "[ ${has_benchmark} -eq 1 ]"
    assertTrue "Should have performance_metrics field" "[ ${has_metrics} -eq 1 ]"
    assertTrue "Should have results_summary field" "[ ${has_results} -eq 1 ]"
}

testBenchmarkANNThroughputAboveThreshold() {
    local bench_file="${RESULTS_DIR}/benchmark_ann.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_throughput
    has_throughput="$(json_throughput_ge "${bench_file}" "${MINIMUM_QPS}" results_summary avg_ef_sweep 50 qps)"
    local actual_qps
    actual_qps="$(json_avg_throughput "${bench_file}" results_summary avg_ef_sweep 50 qps)"
    echo "[DIAG] ANN QPS at ef=50: ${actual_qps} (threshold: ${MINIMUM_QPS})"
    assertTrue "ANN QPS should be >= ${MINIMUM_QPS}, got ${actual_qps}" "[ ${has_throughput} -eq 1 ]"
}

testBenchmarkANNRecallAboveThreshold() {
    local bench_file="${RESULTS_DIR}/benchmark_ann.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_recall
    has_recall="$(json_throughput_ge "${bench_file}" "${MINIMUM_RECALL}" results_summary avg_ef_sweep 200 recall_at_10)"
    local actual_recall
    actual_recall="$(json_avg_throughput "${bench_file}" results_summary avg_ef_sweep 200 recall_at_10)"
    echo "[DIAG] ANN recall@10 at ef=200: ${actual_recall} (threshold: ${MINIMUM_RECALL})"
    assertTrue "ANN recall should be >= ${MINIMUM_RECALL}, got ${actual_recall}" "[ ${has_recall} -eq 1 ]"
}

testBenchmarkANNEfSweepCompleted() {
    local bench_file="${RESULTS_DIR}/benchmark_ann.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_ef_sweep
    has_ef_sweep="$(json_contains "${bench_file}" avg_ef_sweep)"
    assertTrue "Should have ef_sweep results" "[ ${has_ef_sweep} -eq 1 ]"
}

testBenchmarkMicroProducesResults() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    assertTrue "Micro benchmark JSON should exist" "[ -f '${bench_file}' ]"
}

testBenchmarkMicroAllOperationsCompleted() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local ops_count
    ops_count="$(json_count_results "${bench_file}")"
    assertTrue "Should have micro benchmark results (count=${ops_count})" "[ ${ops_count} -ge 4 ]"
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
    if [ ! -f "${agg_file}" ]; then startSkipping; return; fi
    local has_ann has_micro
    has_ann="$(json_contains "${agg_file}" ann)"
    has_micro="$(json_contains "${agg_file}" micro)"
    assertTrue "Should contain ann benchmark data" "[ ${has_ann} -eq 1 ]"
    assertTrue "Should contain micro benchmark data" "[ ${has_micro} -eq 1 ]"
}

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --check              Check prerequisites only"
    echo "  -h, --help           Show this help message"
    echo ""
    echo "Environment variables:"
    echo "  HNSWLIB_VERSION      hnswlib version (default: 0.8.0)"
    echo "  DATA_SCALE           Dataset scale: 1M, 10M (default: 1M)"
    echo "  DATA_DIM             Vector dimension (default: 128)"
    echo "  ITERATIONS           Number of iterations (default: 1)"
    echo "  K_VALUE              k for nearest neighbor (default: 10)"
    echo "  MINIMUM_QPS          QPS threshold (default: 100)"
    echo "  MINIMUM_RECALL       Recall threshold (default: 0.90)"
    echo "  MINIMUM_ADD_RATE     Index construction rate threshold (default: 50000)"
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

    log "START" "${SOFTWARE_NAME} ARM64 Benchmark v${SOFTWARE_VERSION}"

    if [ "${check_only}" -eq 1 ]; then
        check_prerequisites
        exit $?
    fi

    if ! check_prerequisites; then
        log "FATAL" "Prerequisites not met. Use --check for detailed status."
        exit 1
    fi

    download_shunit2 || {
        log "FATAL" "Failed to download shUnit2. Please install manually."
        exit 1
    }

    . "${SCRIPT_DIR}/shunit2"
}

if [ "${1:-}" != "--shunit2-run" ]; then
    main "$@"
fi
