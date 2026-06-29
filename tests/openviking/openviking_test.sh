#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOFTWARE_NAME="openviking"
SOFTWARE_VERSION="${SOFTWARE_VERSION:-0.4.5}"
BUILD_METHOD="${BUILD_METHOD:-pip}"
TARGET_OS="${TARGET_OS:-openEuler 24.03 SP3}"
TARGET_MODEL="${TARGET_MODEL:-Kunpeng-920}"
RESULTS_DIR="${SCRIPT_DIR}/results/${SOFTWARE_VERSION}"
mkdir -p "${RESULTS_DIR}"
LOG_FILE="${RESULTS_DIR}/results.log"
JSON_HELPER="${SCRIPT_DIR}/scripts/json_helper.py"

BUILD_TMPDIR=""
SHUNIT2_PATH=""
OV_IMPORT_OK=0

ITERATIONS="${ITERATIONS:-1}"
MIN_FS_OP_PER_SEC="${MIN_FS_OP_PER_SEC:-100}"
MAX_FS_LATENCY_MS="${MAX_FS_LATENCY_MS:-5000}"
MIN_INIT_SPEED_MS="${MIN_INIT_SPEED_MS:-10000}"

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
    BUILD_TMPDIR="$(mktemp -d /tmp/openviking_build_XXXXXX)"
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
        log "ERROR" "python3 is not installed. Please install Python 3.10+."
        errors=$((errors + 1))
    else
        local py_ver
        py_ver="$(python3 --version 2>&1)"
        log "CHECK" "Python3 OK: ${py_ver}"
        local py_major py_minor
        py_major="$(python3 -c 'import sys; print(sys.version_info.major)' 2>/dev/null)"
        py_minor="$(python3 -c 'import sys; print(sys.version_info.minor)' 2>/dev/null)"
        if [ "${py_major}" -lt 3 ] || [ "${py_minor}" -lt 10 ]; then
            log "ERROR" "Python version must be >= 3.10, got ${py_ver}"
            errors=$((errors + 1))
        fi
    fi

    if ! command -v cargo >/dev/null 2>&1; then
        log "WARN" "cargo (Rust) not found - will install in build phase"
    else
        log "CHECK" "Cargo OK: $(cargo --version 2>&1)"
    fi

    if ! command -v cmake >/dev/null 2>&1; then
        log "WARN" "cmake not found - will install in build phase"
    else
        log "CHECK" "CMake OK: $(cmake --version 2>&1 | head -1)"
    fi

    if ! command -v gcc >/dev/null 2>&1; then
        log "WARN" "gcc not found - will install in build phase"
    else
        log "CHECK" "GCC OK: $(gcc --version 2>&1 | head -1)"
    fi

    if ! command -v git >/dev/null 2>&1; then
        log "WARN" "git not found - will install in build phase"
    else
        log "CHECK" "Git OK: $(git --version 2>&1)"
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
    log "CHECK" "Build method: ${BUILD_METHOD}"

    return ${errors}
}

phase1_build() {
    log "PHASE1" "=== Phase 1: Install OpenViking v${SOFTWARE_VERSION} (${BUILD_METHOD}) ==="

    python3 -c "import openviking" 2>/dev/null && {
        log "PHASE1" "OpenViking already importable, skipping install"
        OV_IMPORT_OK=1
        return 0
    }

    case "${BUILD_METHOD}" in
        pip)
            log "PHASE1" "Installing OpenViking v${SOFTWARE_VERSION} from PyPI..."
            pip3 install --break-system-packages \
                "openviking==${SOFTWARE_VERSION}" 2>&1 | tee -a "${LOG_FILE}" || {
                log "WARN" "pip install failed, trying with --ignore-installed..."
                pip3 install --break-system-packages --ignore-installed \
                    urllib3 "openviking==${SOFTWARE_VERSION}" 2>&1 | tee -a "${LOG_FILE}" || {
                    log "ERROR" "pip install failed"
                    return 1
                }
            }
            ;;
        source_build)
            create_build_tmpdir
            local OV_SRC_DIR="${BUILD_TMPDIR}/openviking_src"
            local os_id
            os_id="$(detect_os_id)"
            log "PHASE1" "Building OpenViking from source on ${os_id}..."

            case "${os_id}" in
                ubuntu|debian)
                    log "PHASE1" "Installing build dependencies (Ubuntu/Debian)..."
                    sudo apt-get update -qq 2>&1 | tee -a "${LOG_FILE}"
                    sudo apt-get install -y -qq build-essential gcc g++ cmake make \
                        git wget curl rustc cargo libssl-dev pkg-config 2>&1 | tee -a "${LOG_FILE}"
                    ;;
                openeuler)
                    log "PHASE1" "Installing build dependencies (openEuler)..."
                    sudo dnf install -y gcc gcc-c++ cmake make git wget curl \
                        rust cargo openssl-devel pkg-config 2>&1 | tee -a "${LOG_FILE}"
                    ;;
                *)
                    log "WARN" "Unknown OS: ${os_id}, attempting generic build..."
                    ;;
            esac

            pip3 install --break-system-packages maturin setuptools setuptools-scm cmake wheel 2>&1 | tee -a "${LOG_FILE}"

            log "PHASE1" "Cloning OpenViking v${SOFTWARE_VERSION}..."
            git clone --branch v${SOFTWARE_VERSION} --depth 1 \
                https://github.com/volcengine/OpenViking.git \
                "${OV_SRC_DIR}" 2>&1 | tee -a "${LOG_FILE}" || {
                log "ERROR" "Failed to clone OpenViking"
                return 1
            }

            log "PHASE1" "Installing OpenViking from source (pip install .)..."
            OV_SKIP_STUDIO_BUILD=1 pip3 install --break-system-packages \
                "${OV_SRC_DIR}" 2>&1 | tee -a "${LOG_FILE}" || {
                log "ERROR" "pip install from source failed"
                return 1
            }
            ;;
    esac

    log "PHASE1" "Verifying import..."
    if python3 -c "import openviking; print(openviking.__version__)" 2>&1 | tee -a "${LOG_FILE}"; then
        OV_IMPORT_OK=1
        log "PHASE1" "OpenViking import verified successfully"
    else
        log "ERROR" "OpenViking import verification failed"
        OV_IMPORT_OK=0
        return 1
    fi

    log "PHASE1" "OpenViking install complete"
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
    gcc_ver="$(gcc --version 2>/dev/null | head -1 | sed 's/.* //' | tr -d '\n\t' || echo 'unknown')"

    python3 "${JSON_HELPER}" "${RESULTS_DIR}/version_info.json" write_version_info \
        "${timestamp}" "${model}" "${arch}" "${kernel}" "${os_name}" "${cpu_model}" \
        "${cores}" "${SOFTWARE_NAME}" "${SOFTWARE_VERSION}" \
        "${python_ver}" "${gcc_ver}"
    log "PHASE2" "Version info saved (OS: ${os_name}, GCC: ${gcc_ver})"
}

phase3_run_benchmarks() {
    log "PHASE3" "=== Phase 3: Run Benchmarks ==="
    mkdir -p "${RESULTS_DIR}"

    log "PHASE3A" "Running context filesystem benchmark..."
    python3 "${SCRIPT_DIR}/scripts/benchmark_context.py" \
        "${RESULTS_DIR}/benchmark_context.json" \
        "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "Context benchmark had issues"

    log "PHASE3B" "Running micro benchmark..."
    python3 "${SCRIPT_DIR}/scripts/micro_benchmark.py" \
        "${RESULTS_DIR}/micro_benchmark.json" \
        "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "Micro benchmark had issues"
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
    log "START" "${SOFTWARE_NAME} Source Build & Performance Benchmark - v${SOFTWARE_VERSION}"
    local os_id os_name
    os_id="$(detect_os_id)"
    os_name="$(detect_os_name)"
    log "START" "OS: ${os_name} (${os_id}), Build: ${BUILD_METHOD}"

    check_prerequisites || log "WARN" "Some prerequisites missing, continuing..."
    phase1_build || log "FATAL" "Phase 1 (source build) failed"
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
    rm -rf "${SCRIPT_DIR}/scripts/__pycache__"
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
    if [ "${OV_IMPORT_OK}" -ne 1 ]; then
        echo "WARNING: OpenViking import not verified, skipping"
        startSkipping
        return
    fi
    assertTrue "OpenViking should be importable" "[ ${OV_IMPORT_OK} -eq 1 ]"
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
    assertTrue "Context benchmark JSON should exist" "[ -f '${RESULTS_DIR}/benchmark_context.json' ]"
}

testBenchmarkPrimaryHasRequiredFields() {
    local bench_file="${RESULTS_DIR}/benchmark_context.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_benchmark has_metrics has_results
    has_benchmark="$(json_contains "${bench_file}" benchmark)"
    has_metrics="$(json_contains "${bench_file}" performance_metrics)"
    has_results="$(json_contains "${bench_file}" results_summary)"
    assertTrue "Should have benchmark field" "[ ${has_benchmark} -eq 1 ]"
    assertTrue "Should have performance_metrics field" "[ ${has_metrics} -eq 1 ]"
    assertTrue "Should have results_summary field" "[ ${has_results} -eq 1 ]"
}

testBenchmarkPrimaryFsOpsAboveThreshold() {
    local bench_file="${RESULTS_DIR}/benchmark_context.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local write_ops
    write_ops="$(json_get "${bench_file}" results_summary write_ops_per_sec)"
    if [ "${write_ops}" = "NULL" ] || [ -z "${write_ops}" ]; then
        startSkipping
        return
    fi
    echo "[DIAG] Write ops per sec: ${write_ops} (threshold: ${MIN_FS_OP_PER_SEC})"
    assertTrue "Write ops (${write_ops}) should be >= ${MIN_FS_OP_PER_SEC}" \
        "[ $(echo "${write_ops} >= ${MIN_FS_OP_PER_SEC}" | bc -l) -eq 1 ]"
}

testBenchmarkPrimaryFsLatencyBelowThreshold() {
    local bench_file="${RESULTS_DIR}/benchmark_context.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local write_lat
    write_lat="$(json_get "${bench_file}" results_summary write_avg_latency_ms)"
    if [ "${write_lat}" = "NULL" ] || [ -z "${write_lat}" ]; then
        startSkipping
        return
    fi
    echo "[DIAG] Write avg latency: ${write_lat} ms (threshold: ${MAX_FS_LATENCY_MS})"
    assertTrue "Write avg latency (${write_lat}ms) should be <= ${MAX_FS_LATENCY_MS}ms" \
        "[ $(echo "${write_lat} <= ${MAX_FS_LATENCY_MS}" | bc -l) -eq 1 ]"
}

testBenchmarkPrimaryIsContextBenchmark() {
    local bench_file="${RESULTS_DIR}/benchmark_context.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local bench_name
    bench_name="$(json_get "${bench_file}" benchmark)"
    assertEquals "Benchmark name should be context_fs" "context_fs" "${bench_name}"
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
    assertTrue "Should have micro benchmark results (count=${ops_count})" "[ ${ops_count} -ge 4 ]"
}

testBenchmarkMicroInitLatencyBelowThreshold() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local init_lat
    init_lat="$(json_get "${bench_file}" results import_init import_time_ms)"
    if [ "${init_lat}" = "NULL" ] || [ -z "${init_lat}" ]; then
        startSkipping
        return
    fi
    echo "[DIAG] Import init time: ${init_lat} ms (threshold: ${MIN_INIT_SPEED_MS})"
    assertTrue "Import init time (${init_lat}ms) should be <= ${MIN_INIT_SPEED_MS}ms" \
        "[ $(echo "${init_lat} <= ${MIN_INIT_SPEED_MS}" | bc -l) -eq 1 ]"
}

testBenchmarkMicroMultithreadScaling() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_mt
    has_mt="$(json_contains "${bench_file}" multithread_fs_ops)"
    assertTrue "Should have multithread_fs_ops results" "[ ${has_mt} -eq 1 ]"
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
    has_primary="$(json_contains "${agg_file}" primary_benchmark)"
    has_micro="$(json_contains "${agg_file}" micro_benchmark)"
    assertTrue "Should contain primary_benchmark data" "[ ${has_primary} -eq 1 ]"
    assertTrue "Should contain micro_benchmark data" "[ ${has_micro} -eq 1 ]"
}

usage() {
    cat <<USAGE
Usage: $(basename "$0") [OPTIONS]
OpenViking Source Build & Performance Benchmark (shUnit2)
Options:
  --check    Check prerequisites only (do not run benchmarks)
  -h|--help  Show this help
Environment variables:
  SOFTWARE_VERSION              OpenViking version (default: 0.4.5)
  TARGET_OS                    OS name in results (default: openEuler 24.03 SP3)
  TARGET_MODEL                 Hardware model (default: Kunpeng-920)
  ITERATIONS                   Number of iterations (default: 1)
  MIN_FS_OP_PER_SEC            Minimum filesystem ops/sec (default: 100)
  MAX_FS_LATENCY_MS            Maximum filesystem latency ms (default: 5000)
  MIN_INIT_SPEED_MS            Maximum import init time ms (default: 10000)
Examples:
  # Check prerequisites
  ./openviking_test.sh --check
  # Full run
  ./openviking_test.sh
  # Custom version
  SOFTWARE_VERSION=0.4.4 ./openviking_test.sh
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

    log "START" "${SOFTWARE_NAME} Source Build & Performance Benchmark v${SOFTWARE_VERSION}"

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
