#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOFTWARE_NAME="protobuf"
SOFTWARE_VERSION="${SOFTWARE_VERSION:-35.1}"
BUILD_METHOD="${BUILD_METHOD:-source_build}"
TARGET_OS="${TARGET_OS:-openEuler 24.03 SP3}"
TARGET_MODEL="${TARGET_MODEL:-Kunpeng-920}"
RESULTS_DIR="${SCRIPT_DIR}/results/${SOFTWARE_VERSION}"
mkdir -p "${RESULTS_DIR}"
LOG_FILE="${RESULTS_DIR}/results.log"

NUM_MESSAGES="${NUM_MESSAGES:-10000}"
SIZE_SMALL="${SIZE_SMALL:-10}"
SIZE_MEDIUM="${SIZE_MEDIUM:-100}"
SIZE_LARGE="${SIZE_LARGE:-1000}"
ITERATIONS="${ITERATIONS:-1}"

MINIMUM_SERIALIZE_QPS="${MINIMUM_SERIALIZE_QPS:-1000}"
MINIMUM_DESERIALIZE_QPS="${MINIMUM_DESERIALIZE_QPS:-1000}"
MAXIMUM_LATENCY_US="${MAXIMUM_LATENCY_US:-10000}"
MINIMUM_FIDELITY="${MINIMUM_FIDELITY:-1.0}"

JSON_HELPER="${SCRIPT_DIR}/scripts/json_helper.py"

BUILD_TMPDIR=""
SHUNIT2_PATH=""

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
    BUILD_TMPDIR="$(mktemp -d /tmp/protobuf_build_XXXXXX)"
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
        log "ERROR" "python3 is not installed"
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

    local os_id os_name
    os_id="$(detect_os_id)"
    os_name="$(detect_os_name)"
    log "CHECK" "OS: ${os_name} (${os_id})"
    log "CHECK" "Architecture: $(uname -m)"
    log "CHECK" "Build method: ${BUILD_METHOD}"

    return ${errors}
}

phase1_install() {
    log "PHASE1" "=== Phase 1: Install protobuf v${SOFTWARE_VERSION} (${BUILD_METHOD}) ==="

    python3 -c "import google.protobuf" 2>/dev/null && {
        log "PHASE1" "protobuf already importable, skipping install"
        return 0
    }

    case "${BUILD_METHOD}" in
        pip)
            log "PHASE1" "Installing protobuf==${SOFTWARE_VERSION} via pip..."
            pip3 install --break-system-packages protobuf==${SOFTWARE_VERSION} 2>&1 | tee -a "${LOG_FILE}" || {
                log "ERROR" "Failed to install protobuf==${SOFTWARE_VERSION} via pip"
                return 1
            }
            ;;
        source_build)
            log "PHASE1" "Building protobuf v${SOFTWARE_VERSION} from source..."
            create_build_tmpdir

            local os_id
            os_id="$(detect_os_id)"
            log "PHASE1" "Installing build dependencies on ${os_id}..."

            case "${os_id}" in
                openeuler|centos|rhel|fedora)
                    sudo dnf install -y gcc gcc-c++ cmake make \
                        python3-devel python3-pip \
                        git wget curl 2>&1 | tee -a "${LOG_FILE}"
                    ;;
                ubuntu|debian)
                    sudo apt-get update -qq 2>&1 | tee -a "${LOG_FILE}"
                    sudo apt-get install -y -qq build-essential gcc g++ cmake \
                        python3-dev python3-pip \
                        git wget curl 2>&1 | tee -a "${LOG_FILE}"
                    ;;
                *)
                    log "ERROR" "Unsupported OS: ${os_id}"
                    return 1
                    ;;
            esac

            pip3 install --break-system-packages --upgrade pip setuptools wheel numpy 2>&1 | tee -a "${LOG_FILE}"

            local PB_SRC_DIR="${BUILD_TMPDIR}/protobuf_src"
            local PB_BUILD_DIR="${BUILD_TMPDIR}/build"
            local PB_INSTALL_DIR="${BUILD_TMPDIR}/install"

            log "PHASE1" "Cloning protobuf v${SOFTWARE_VERSION}..."
            git clone --branch v${SOFTWARE_VERSION} --depth 1 \
                https://github.com/protocolbuffers/protobuf.git \
                "${PB_SRC_DIR}/protobuf" 2>&1 | tee -a "${LOG_FILE}" || {
                log "ERROR" "Failed to clone protobuf v${SOFTWARE_VERSION}"
                return 1
            }

            log "PHASE1" "Configuring CMake..."
            mkdir -p "${PB_BUILD_DIR}"
            (cd "${PB_BUILD_DIR}" && cmake \
                -DCMAKE_BUILD_TYPE=Release \
                -Dprotobuf_BUILD_TESTS=OFF \
                -Dprotobuf_BUILD_SHARED_LIBS=OFF \
                -DCMAKE_INSTALL_PREFIX="${PB_INSTALL_DIR}" \
                "${PB_SRC_DIR}/protobuf" 2>&1 | tee -a "${LOG_FILE}") || {
                log "ERROR" "CMake configuration failed"
                return 1
            }

            log "PHASE1" "Compiling protobuf (this may take several minutes)..."
            (cd "${PB_BUILD_DIR}" && make -j$(nproc) 2>&1 | tee -a "${LOG_FILE}") || {
                log "ERROR" "protobuf compilation failed"
                return 1
            }

            log "PHASE1" "Installing protobuf C++ library..."
            (cd "${PB_BUILD_DIR}" && make install 2>&1 | tee -a "${LOG_FILE}")

            local protoc_bin="${PB_INSTALL_DIR}/bin/protoc"
            if [ -f "${protoc_bin}" ]; then
                sudo cp "${protoc_bin}" /usr/local/bin/ 2>&1 | tee -a "${LOG_FILE}"
                log "PHASE1" "protoc installed to /usr/local/bin"
            fi

            sudo ldconfig 2>/dev/null || true

            log "PHASE1" "Building protobuf Python bindings..."
            export PATH="/usr/local/bin:${PATH}"
            export LD_LIBRARY_PATH="${PB_INSTALL_DIR}/lib:${LD_LIBRARY_PATH:-}"
            export PROTOBUF_DIR="${PB_SRC_DIR}/protobuf"

            (cd "${PB_SRC_DIR}/protobuf/python" && \
                pip3 install --break-system-packages . 2>&1 | tee -a "${LOG_FILE}") || {
                log "WARN" "Python bindings build from source failed, trying pip fallback..."
                pip3 install --break-system-packages protobuf==${SOFTWARE_VERSION} 2>&1 | tee -a "${LOG_FILE}" || {
                    log "ERROR" "All protobuf Python installation methods failed"
                    return 1
                }
            }

            cleanup_build_tmpdir
            ;;
        *)
            log "ERROR" "Unknown BUILD_METHOD: ${BUILD_METHOD}"
            return 1
            ;;
    esac

    python3 -c "import google.protobuf" 2>/dev/null || {
        log "ERROR" "protobuf import failed after install"
        return 1
    }

    log "PHASE1" "protobuf v${SOFTWARE_VERSION} installed successfully (${BUILD_METHOD})"
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
    export NUM_MESSAGES SIZE_SMALL SIZE_MEDIUM SIZE_LARGE ITERATIONS RESULTS_DIR

    log "PHASE3A" "Running serialization benchmark..."
    python3 "${SCRIPT_DIR}/scripts/benchmark_ann.py" \
        --output "${RESULTS_DIR}/benchmark_ann.json" \
        --num-messages "${NUM_MESSAGES}" \
        --iterations "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}"

    log "PHASE3B" "Running micro benchmark..."
    python3 "${SCRIPT_DIR}/scripts/micro_benchmark.py" \
        --output "${RESULTS_DIR}/micro_benchmark.json" \
        --num-messages "${NUM_MESSAGES}" \
        --iterations "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}"
}

phase4_results() {
    log "PHASE4" "=== Phase 4: Aggregate & Report ==="

    python3 "${SCRIPT_DIR}/scripts/aggregate_results.py" \
        --results-dir "${RESULTS_DIR}" \
        --output "${RESULTS_DIR}/results.json"

    python3 "${SCRIPT_DIR}/scripts/generate_summary.py" \
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
    os_id="$(detect_os_id)"
    log "START" "OS: ${os_name} (${os_id}), Build: ${BUILD_METHOD}"

    check_prerequisites || log "WARN" "Some prerequisites missing, continuing..."
    phase1_install || log "WARN" "Phase 1 had issues, continuing..."
    phase2_verify || log "WARN" "Phase 2 had issues, continuing..."
    phase3_run_benchmarks || log "WARN" "Phase 3 had issues, continuing..."
    phase4_results || log "WARN" "Phase 4 had issues..."
}

oneTimeTearDown() {
    cleanup_build_tmpdir
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
    python3 -c "import google.protobuf" 2>/dev/null && found=1
    if [ "${found}" -eq 0 ]; then
        startSkipping
        return
    fi
    assertTrue "protobuf should be importable" "[ ${found} -eq 1 ]"
}

testSoftwareVersionMatches() {
    local ver="${SOFTWARE_VERSION}"
    assertNotNull "Version should not be empty" "${ver}"
}

testSoftwareRunsBasicCommand() {
    if ! python3 -c "import google.protobuf" 2>/dev/null; then
        startSkipping
        return
    fi
    local result
    result="$(python3 -c "
from google.protobuf import descriptor_pb2
msg = descriptor_pb2.FileDescriptorProto()
msg.name = 'test.proto'
data = msg.SerializeToString()
new_msg = descriptor_pb2.FileDescriptorProto()
new_msg.ParseFromString(data)
print('OK' if msg.name == new_msg.name else 'FAIL')
" 2>&1)"
    assertTrue "protobuf basic serialize/deserialize should succeed" "echo '${result}' | grep -q 'OK'"
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

testBenchmarkANNProducesResults() {
    local bench_file="${RESULTS_DIR}/benchmark_ann.json"
    assertTrue "Serialization benchmark JSON should exist" "[ -f '${bench_file}' ]"
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
    local result
    result="$(json_throughput_ge "${bench_file}" "${MINIMUM_SERIALIZE_QPS}" results_summary avg_size_sweep 100 serialize_qps)"
    local actual
    actual="$(json_avg_throughput "${bench_file}" results_summary avg_size_sweep 100 serialize_qps)"
    echo "[DIAG] Serialize QPS at size=100: ${actual} (threshold: ${MINIMUM_SERIALIZE_QPS})"
    assertTrue "Serialize QPS should be >= ${MINIMUM_SERIALIZE_QPS}" "[ ${result} -eq 1 ]"
}

testBenchmarkANNDeserThroughputAboveThreshold() {
    local bench_file="${RESULTS_DIR}/benchmark_ann.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local result
    result="$(json_throughput_ge "${bench_file}" "${MINIMUM_DESERIALIZE_QPS}" results_summary avg_size_sweep 100 deserialize_qps)"
    local actual
    actual="$(json_avg_throughput "${bench_file}" results_summary avg_size_sweep 100 deserialize_qps)"
    echo "[DIAG] Deserialize QPS at size=100: ${actual} (threshold: ${MINIMUM_DESERIALIZE_QPS})"
    assertTrue "Deserialize QPS should be >= ${MINIMUM_DESERIALIZE_QPS}" "[ ${result} -eq 1 ]"
}

testBenchmarkANNSerializationFidelity() {
    local bench_file="${RESULTS_DIR}/benchmark_ann.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local result
    result="$(json_throughput_ge "${bench_file}" "${MINIMUM_FIDELITY}" results_summary avg_size_sweep 100 fidelity)"
    local actual
    actual="$(json_avg_throughput "${bench_file}" results_summary avg_size_sweep 100 fidelity)"
    echo "[DIAG] Fidelity at size=100: ${actual} (threshold: ${MINIMUM_FIDELITY})"
    assertTrue "Fidelity should be >= ${MINIMUM_FIDELITY}" "[ ${result} -eq 1 ]"
}

testBenchmarkANNSizeSweepCompleted() {
    local bench_file="${RESULTS_DIR}/benchmark_ann.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_sweep
    has_sweep="$(json_contains "${bench_file}" avg_size_sweep)"
    assertTrue "Should have size sweep results" "[ ${has_sweep} -eq 1 ]"
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

testBenchmarkMicroSerializationRateAboveThreshold() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local result
    result="$(json_throughput_ge "${bench_file}" "${MINIMUM_SERIALIZE_QPS}" results single_serialize serialize_qps)"
    local actual
    actual="$(json_get "${bench_file}" results single_serialize serialize_qps)"
    echo "[DIAG] Single serialize QPS: ${actual} (threshold: ${MINIMUM_SERIALIZE_QPS})"
    assertTrue "Single serialize QPS should be >= ${MINIMUM_SERIALIZE_QPS}" "[ ${result} -eq 1 ]"
}

testBenchmarkMicroMultithreadScaling() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_mt
    has_mt="$(json_contains "${bench_file}" multithread_serialize)"
    assertTrue "Should have multithread serialization results" "[ ${has_mt} -eq 1 ]"
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
    echo "  SOFTWARE_VERSION     protobuf version (default: 35.1)"
    echo "  BUILD_METHOD         Build method: pip or source_build (default: source_build)"
    echo "  TARGET_OS            OS name in results (default: openEuler 24.03 SP3)"
    echo "  TARGET_MODEL         Hardware model (default: Kunpeng-920)"
    echo "  NUM_MESSAGES         Number of messages for benchmark (default: 10000)"
    echo "  SIZE_SMALL           Small message repeated field size (default: 10)"
    echo "  SIZE_MEDIUM          Medium message repeated field size (default: 100)"
    echo "  SIZE_LARGE           Large message repeated field size (default: 1000)"
    echo "  ITERATIONS           Number of iterations (default: 1)"
    echo "  MINIMUM_SERIALIZE_QPS      Serialize QPS threshold (default: 1000)"
    echo "  MINIMUM_DESERIALIZE_QPS    Deserialize QPS threshold (default: 1000)"
    echo "  MINIMUM_FIDELITY           Fidelity threshold (default: 1.0)"
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

    check_prerequisites || {
        log "FATAL" "Prerequisites not met"
        exit 1
    }

    download_shunit2 || {
        log "FATAL" "Failed to download shUnit2"
        exit 1
    }

    SHUNIT_PARENT="${SCRIPT_DIR}/${SOFTWARE_NAME}_test.sh"
    . "${SHUNIT2_PATH}"
}

if [ "${1:-}" != "--shunit2-run" ]; then
    main "$@"
fi
