#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOFTWARE_NAME="sonic"
SOFTWARE_VERSION="${SOFTWARE_VERSION:-1.0.2}"
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
COMPARE_BIN=""

ITERATIONS="${ITERATIONS:-1}"

MIN_PARSE_QPS="${MIN_PARSE_QPS:-100}"
MIN_SERIALIZE_QPS="${MIN_SERIALIZE_QPS:-100}"
MIN_PARSE_THROUGHPUT_MBS="${MIN_PARSE_THROUGHPUT_MBS:-50}"

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

detect_os_id() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "${ID}"
    else
        echo "unknown"
    fi
}

detect_os_name() {
    echo "${TARGET_OS}"
}

create_build_tmpdir() {
    BUILD_TMPDIR="$(mktemp -d /tmp/sonic_build_XXXXXX)"
    log "BUILD" "Created temp build directory: ${BUILD_TMPDIR}"
}

cleanup_build_tmpdir() {
    if [ -n "${BUILD_TMPDIR}" ] && [ -d "${BUILD_TMPDIR}" ]; then
        log "BUILD" "Cleaning up temp build directory: ${BUILD_TMPDIR}"
        rm -rf "${BUILD_TMPDIR}"
        BUILD_TMPDIR=""
    fi
}

download_shunit2() {
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

    if ! command -v g++ >/dev/null 2>&1; then
        log "ERROR" "g++ is not installed (need C++17 support)"
        errors=$((errors + 1))
    else
        log "CHECK" "GCC OK: $(g++ --version 2>&1 | head -1)"
    fi

    if ! command -v git >/dev/null 2>&1; then
        log "WARN" "git not found - will install in build phase"
    else
        log "CHECK" "Git OK: $(git --version 2>&1)"
    fi

    if ! command -v curl >/dev/null 2>&1; then
        log "WARN" "curl not found - needed for competitor clone fallback"
    fi

    if [ ! -f "${JSON_HELPER}" ]; then
        log "ERROR" "json_helper.py not found at ${JSON_HELPER}"
        errors=$((errors + 1))
    else
        log "CHECK" "json_helper.py OK"
    fi

    local os_id os_name
    os_id="$(detect_os_id)"
    os_name="$(detect_os_name)"
    log "CHECK" "OS: ${os_name} (${os_id})"
    log "CHECK" "Architecture: $(uname -m)"
    log "CHECK" "Build method: ${BUILD_METHOD} (header-only, no lib build needed)"

    return ${errors}
}

phase1_build() {
    log "PHASE1" "=== Phase 1: Build sonic v${SOFTWARE_VERSION} (header-only) + benchmark ==="

    create_build_tmpdir

    local SONIC_SRC_DIR="${BUILD_TMPDIR}/sonic_src"
    local os_id
    os_id="$(detect_os_id)"
    log "PHASE1" "Preparing build env on ${os_id}..."

    local os_id_lower
    os_id_lower="$(echo "${os_id}" | tr '[:upper:]' '[:lower:]')"
    case "${os_id_lower}" in
        ubuntu|debian)
            sudo apt-get update -qq 2>&1 | tee -a "${LOG_FILE}" >/dev/null
            sudo apt-get install -y -qq build-essential g++ git wget curl 2>&1 | tee -a "${LOG_FILE}" >/dev/null
            ;;
        openeuler)
            sudo dnf install -y gcc gcc-c++ git wget curl 2>&1 | tee -a "${LOG_FILE}" >/dev/null
            ;;
        centos|rhel|fedora)
            sudo dnf install -y gcc gcc-c++ git wget curl 2>&1 | tee -a "${LOG_FILE}" >/dev/null
            ;;
        *)
            log "WARN" "Unknown OS: ${os_id}, attempting generic build..."
            ;;
    esac

    local ver_tag="${SOFTWARE_VERSION}"
    [ "${ver_tag:0:1}" = "v" ] || ver_tag="v${ver_tag}"
    log "PHASE1" "Cloning sonic-cpp tag ${ver_tag}..."
    git clone --branch "${ver_tag}" --depth 1 \
        https://github.com/bytedance/sonic-cpp.git \
        "${SONIC_SRC_DIR}" 2>&1 | tee -a "${LOG_FILE}" || {
        log "ERROR" "Failed to clone sonic-cpp tag ${ver_tag}"
        return 1
    }

    local SONIC_INC="${SONIC_SRC_DIR}/include"
    if [ ! -f "${SONIC_INC}/sonic/sonic.h" ]; then
        log "ERROR" "sonic header not found at ${SONIC_INC}/sonic/sonic.h"
        return 1
    fi
    log "PHASE1" "sonic headers found at ${SONIC_INC} (header-only, no lib build)"

    log "PHASE1" "Compiling single-library benchmark (sonic_benchmark.cc)..."
    BENCHMARK_BIN="${BUILD_TMPDIR}/sonic_benchmark"
    g++ -O2 -std=c++17 \
        -I"${SONIC_INC}" \
        "${SCRIPT_DIR}/scripts/sonic_benchmark.cc" \
        -lpthread \
        -o "${BENCHMARK_BIN}" 2>&1 | tee -a "${LOG_FILE}" || {
        log "ERROR" "sonic_benchmark compilation failed"
        return 1
    }

    log "PHASE1" "Verifying benchmark binary..."
    if [ -x "${BENCHMARK_BIN}" ]; then
        "${BENCHMARK_BIN}" json 1 "${BUILD_TMPDIR}/test_verify.json" 2>&1 | tee -a "${LOG_FILE}" || {
            log "WARN" "Benchmark verification run failed"
        }
        if [ -f "${BUILD_TMPDIR}/test_verify.json" ]; then
            log "PHASE1" "Benchmark binary verified successfully"
            rm -f "${BUILD_TMPDIR}/test_verify.json"
        fi
    else
        log "ERROR" "Benchmark binary not executable"
        return 1
    fi

    log "PHASE1" "Attempting head-to-head competitor clone (optional)..."
    local RAPIDJSON_SRC="${BUILD_TMPDIR}/rapidjson"
    local YYJSON_SRC="${BUILD_TMPDIR}/yyjson"
    local NLOHMANN_SRC="${BUILD_TMPDIR}/nlohmann"
    local comp_ok=1

    git clone --depth 1 https://github.com/rapidjson/rapidjson.git "${RAPIDJSON_SRC}" 2>&1 | tee -a "${LOG_FILE}" || {
        log "WARN" "rapidjson clone failed - head-to-head will be skipped"
        comp_ok=0
    }
    if [ "${comp_ok}" -eq 1 ]; then
        git clone --depth 1 https://github.com/Realtin/yyjson.git "${YYJSON_SRC}" 2>&1 | tee -a "${LOG_FILE}" || {
            log "WARN" "yyjson clone failed - head-to-head will be skipped"
            comp_ok=0
        }
    fi
    if [ "${comp_ok}" -eq 1 ]; then
        git clone --depth 1 https://github.com/nlohmann/json.git "${NLOHMANN_SRC}" 2>&1 | tee -a "${LOG_FILE}" || {
            log "WARN" "nlohmann/json clone failed - head-to-head will be skipped"
            comp_ok=0
        }
    fi

    if [ "${comp_ok}" -eq 1 ] && [ -f "${YYJSON_SRC}/yyjson.h" ] && [ -f "${YYJSON_SRC}/yyjson.c" ] \
       && [ -d "${NLOHMANN_SRC}/single_include" ] && [ -d "${RAPIDJSON_SRC}/include" ]; then
        log "PHASE1" "All competitors cloned. Compiling head-to-head binary (sonic_compare.cc)..."
        COMPARE_BIN="${BUILD_TMPDIR}/sonic_compare"
        g++ -O2 -std=c++17 \
            -I"${SONIC_INC}" \
            -I"${RAPIDJSON_SRC}/include" \
            -I"${YYJSON_SRC}" \
            -I"${NLOHMANN_SRC}/single_include" \
            "${SCRIPT_DIR}/scripts/sonic_compare.cc" \
            "${YYJSON_SRC}/yyjson.c" \
            -lpthread \
            -o "${COMPARE_BIN}" 2>&1 | tee -a "${LOG_FILE}" || {
            log "WARN" "sonic_compare compilation failed - head-to-head mode will be skipped"
            COMPARE_BIN=""
        }
        if [ -n "${COMPARE_BIN}" ] && [ -x "${COMPARE_BIN}" ]; then
            log "PHASE1" "Head-to-head binary compiled successfully"
        else
            COMPARE_BIN=""
        fi
    else
        log "PHASE1" "Not all competitors available - head-to-head mode will be skipped"
        COMPARE_BIN=""
    fi

    log "PHASE1" "Build phase complete"
}

phase2_verify() {
    log "PHASE2" "=== Phase 2: Collect Version Info ==="
    local timestamp model arch kernel os_name cpu_model cores python_ver gcc_ver
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

    log "PHASE3A" "Running JSON benchmark (single-library, sonic)..."
    python3 "${SCRIPT_DIR}/scripts/benchmark_json.py" \
        "${BENCHMARK_BIN}" \
        "${RESULTS_DIR}/benchmark_json.json" \
        "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "JSON benchmark had issues"

    log "PHASE3B" "Running micro benchmark..."
    python3 "${SCRIPT_DIR}/scripts/micro_benchmark.py" \
        "${BENCHMARK_BIN}" \
        "${RESULTS_DIR}/micro_benchmark.json" \
        "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "Micro benchmark had issues"

    if [ -n "${COMPARE_BIN}" ] && [ -x "${COMPARE_BIN}" ]; then
        log "PHASE3C" "Running head-to-head comparison benchmark..."
        python3 "${SCRIPT_DIR}/scripts/benchmark_compare.py" \
            "${COMPARE_BIN}" \
            "${RESULTS_DIR}/benchmark_compare.json" \
            "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "Compare benchmark had issues"
    else
        log "PHASE3C" "Head-to-head binary not available - skipping compare benchmark"
    fi
}

phase4_results() {
    log "PHASE4" "=== Phase 4: Aggregate & Report ==="

    python3 "${SCRIPT_DIR}/scripts/aggregate_results.py" \
        "${RESULTS_DIR}" "${RESULTS_DIR}/results.json"

    python3 "${SCRIPT_DIR}/scripts/generate_summary.py" \
        "${RESULTS_DIR}/results.json" "${RESULTS_DIR}/results.txt"

    log "PHASE4" "Reports generated:"
    log "PHASE4" "  JSON: ${RESULTS_DIR}/results.json"
    log "PHASE4" "  TXT:  ${RESULTS_DIR}/results.txt"
    log "PHASE4" "  LOG:  ${RESULTS_DIR}/results.log"
}

oneTimeSetUp() {
    mkdir -p "${RESULTS_DIR}"
    log "START" "${SOFTWARE_NAME} (sonic-cpp) Source Build & Performance Benchmark - v${SOFTWARE_VERSION}"
    local os_id os_name
    os_id="$(detect_os_id)"
    os_name="$(detect_os_name)"
    log "START" "OS: ${os_name} (${os_id}), Build: ${BUILD_METHOD}"

    check_prerequisites || log "WARN" "Some prerequisites missing, continuing..."
    phase1_build || log "FATAL" "Phase 1 (build) failed"
    phase2_verify || log "WARN" "Phase 2 had issues, continuing..."
    phase3_run_benchmarks || log "WARN" "Phase 3 had issues, continuing..."
    phase4_results || log "WARN" "Phase 4 had issues..."
}

oneTimeTearDown() {
    cleanup_build_tmpdir
    if [ -n "${SHUNIT2_PATH}" ]; then
        local shunit2_dir="$(dirname "${SHUNIT2_PATH}")"
        rm -rf "${shunit2_dir}"
        SHUNIT2_PATH=""
    fi
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
    if [ -n "${BENCHMARK_BIN}" ] && [ -x "${BENCHMARK_BIN}" ]; then found=1; fi
    if [ "${found}" -eq 0 ]; then
        echo "WARNING: sonic benchmark binary not found, skipping install check"
        startSkipping
        return
    fi
    assertTrue "sonic benchmark binary should be executable" "[ ${found} -eq 1 ]"
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
    local has_arch
    has_arch="$(json_field_exists "${vfile}" architecture)"
    assertTrue "Version info should have architecture field" "[ ${has_arch} -eq 1 ]"
}

testVersionInfoHasSoftwareVersion() {
    local vfile="${RESULTS_DIR}/version_info.json"
    if [ ! -f "${vfile}" ]; then startSkipping; return; fi
    local has_ver
    has_ver="$(json_field_exists "${vfile}" software_version)"
    assertTrue "Version info should have software_version field" "[ ${has_ver} -eq 1 ]"
}

testBenchmarkPrimaryProducesResults() {
    assertTrue "JSON benchmark JSON should exist" "[ -f '${RESULTS_DIR}/benchmark_json.json' ]"
}

testBenchmarkPrimaryHasRequiredFields() {
    local bench_file="${RESULTS_DIR}/benchmark_json.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_benchmark has_metrics has_results
    has_benchmark="$(json_contains "${bench_file}" benchmark)"
    has_metrics="$(json_contains "${bench_file}" performance_metrics)"
    has_results="$(json_contains "${bench_file}" results_summary)"
    assertTrue "Should have benchmark field" "[ ${has_benchmark} -eq 1 ]"
    assertTrue "Should have performance_metrics field" "[ ${has_metrics} -eq 1 ]"
    assertTrue "Should have results_summary field" "[ ${has_results} -eq 1 ]"
}

testBenchmarkPrimaryParseQpsAboveThreshold() {
    local bench_file="${RESULTS_DIR}/benchmark_json.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local qps
    qps="$(json_get "${bench_file}" results_summary parse_large qps)"
    if [ "${qps}" = "NULL" ] || [ -z "${qps}" ]; then
        startSkipping
        return
    fi
    echo "[DIAG] Large doc parse QPS: ${qps} (threshold: ${MIN_PARSE_QPS})"
    assertTrue "Large doc parse QPS (${qps}) should be >= ${MIN_PARSE_QPS}" \
        "[ $(echo "${qps} >= ${MIN_PARSE_QPS}" | bc -l) -eq 1 ]"
}

testBenchmarkPrimarySerializeQpsAboveThreshold() {
    local bench_file="${RESULTS_DIR}/benchmark_json.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local qps
    qps="$(json_get "${bench_file}" results_summary serialize_large qps)"
    if [ "${qps}" = "NULL" ] || [ -z "${qps}" ]; then
        startSkipping
        return
    fi
    echo "[DIAG] Large doc serialize QPS: ${qps} (threshold: ${MIN_SERIALIZE_QPS})"
    assertTrue "Large doc serialize QPS (${qps}) should be >= ${MIN_SERIALIZE_QPS}" \
        "[ $(echo "${qps} >= ${MIN_SERIALIZE_QPS}" | bc -l) -eq 1 ]"
}

testBenchmarkPrimaryIsJson() {
    local bench_file="${RESULTS_DIR}/benchmark_json.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local bench_name
    bench_name="$(json_get "${bench_file}" benchmark)"
    assertEquals "Benchmark name should be json" "json" "${bench_name}"
}

testBenchmarkMicroProducesResults() {
    assertTrue "Micro benchmark JSON should exist" "[ -f '${RESULTS_DIR}/micro_benchmark.json' ]"
}

testBenchmarkMicroHasRequiredFields() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_benchmark has_metrics has_results
    has_benchmark="$(json_contains "${bench_file}" benchmark)"
    has_metrics="$(json_contains "${bench_file}" performance_metrics)"
    has_results="$(json_contains "${bench_file}" results)"
    assertTrue "Should have benchmark field" "[ ${has_benchmark} -eq 1 ]"
    assertTrue "Should have performance_metrics field" "[ ${has_metrics} -eq 1 ]"
    assertTrue "Should have results field" "[ ${has_results} -eq 1 ]"
}

testBenchmarkMicroAllOperationsCompleted() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local ops_count
    ops_count="$(json_count_results "${bench_file}")"
    assertTrue "Should have micro benchmark results (count=${ops_count})" "[ ${ops_count} -ge 2 ]"
}

testBenchmarkMicroMultithreadScaling() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_mt
    has_mt="$(json_contains "${bench_file}" multithread_parse)"
    assertTrue "Should have multithread parse results" "[ ${has_mt} -eq 1 ]"
}

testBenchmarkCompareProducesResults() {
    local bench_file="${RESULTS_DIR}/benchmark_compare.json"
    if [ ! -f "${bench_file}" ]; then
        echo "[DIAG] benchmark_compare.json not present (head-to-head mode skipped)"
        startSkipping
        return
    fi
    assertTrue "Head-to-head compare should have results_summary" \
        "[ $(json_contains "${bench_file}" results_summary) -eq 1 ]"
}

testBenchmarkCompareHasSonicVsCompetitors() {
    local bench_file="${RESULTS_DIR}/benchmark_compare.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_sonic has_rapidjson
    has_sonic="$(json_contains "${bench_file}" sonic_parse)"
    has_rapidjson="$(json_contains "${bench_file}" rapidjson_parse)"
    assertTrue "Should contain sonic_parse results" "[ ${has_sonic} -eq 1 ]"
    assertTrue "Should contain competitor (rapidjson_parse) results" "[ ${has_rapidjson} -eq 1 ]"
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
    local has_primary has_micro
    has_primary="$(json_contains "${agg_file}" primary)"
    has_micro="$(json_contains "${agg_file}" micro)"
    assertTrue "Should contain benchmarks.primary data" "[ ${has_primary} -eq 1 ]"
    assertTrue "Should contain benchmarks.micro data" "[ ${has_micro} -eq 1 ]"
}

usage() {
    cat <<USAGE
Usage: $(basename "$0") [OPTIONS]
sonic-cpp (sonic) Source Build & Performance Benchmark (shUnit2)
Options:
  --check    Check prerequisites only (do not run benchmarks)
  -h|--help  Show this help
Environment variables:
  SOFTWARE_VERSION          sonic version (default: 1.0.2; supported: 1.0.2, 1.0.0)
  TARGET_OS                OS name in results (default: openEuler 24.03 SP3)
  TARGET_MODEL             Hardware model (default: Kunpeng-920)
  ITERATIONS               Number of iterations (default: 1)
  MIN_PARSE_QPS            Minimum large-doc parse QPS threshold (default: 100)
  MIN_SERIALIZE_QPS        Minimum large-doc serialize QPS threshold (default: 100)
  MIN_PARSE_THROUGHPUT_MBS Minimum parse throughput MB/s threshold (default: 50)
Examples:
  # Check prerequisites
  ./sonic_test.sh --check
  # Full run (single-library + head-to-head vs rapidjson/yyjson/nlohmann)
  ./sonic_test.sh
  # More iterations for stable numbers
  ITERATIONS=5 ./sonic_test.sh
  # sonic 1.0.0 (baseline)
  SOFTWARE_VERSION=1.0.0 ./sonic_test.sh
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

    log "START" "${SOFTWARE_NAME} (sonic-cpp) Source Build & Performance Benchmark v${SOFTWARE_VERSION}"

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

    SHUNIT_PARENT="${SCRIPT_DIR}/${SOFTWARE_NAME}_test.sh"
    . "${SHUNIT2_PATH}"
}

if [ "${1:-}" != "--shunit2-run" ]; then
    main "$@"
fi
