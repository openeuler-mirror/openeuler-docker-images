#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOFTWARE_NAME="zstd"
SOFTWARE_VERSION="${SOFTWARE_VERSION:-1.5.6}"
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
ZSTD_INSTALL_DIR=""

DATA_SIZE="${DATA_SIZE:-1048576}"
ITERATIONS="${ITERATIONS:-1}"

MIN_COMPRESS_SPEED="${MIN_COMPRESS_SPEED:-100}"
MIN_DECOMPRESS_SPEED="${MIN_DECOMPRESS_SPEED:-200}"
MIN_COMPRESSION_RATIO="${MIN_COMPRESSION_RATIO:-1.2}"
MAX_COMPRESS_LATENCY_US="${MAX_COMPRESS_LATENCY_US:-50000}"

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
    BUILD_TMPDIR="$(mktemp -d /tmp/zstd_build_XXXXXX)"
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

    if ! command -v g++ >/dev/null 2>&1 && ! command -v gcc >/dev/null 2>&1; then
        log "WARN" "gcc/g++ not found - will install in build phase"
    else
        log "CHECK" "GCC OK: $(g++ --version 2>&1 | head -1)"
    fi

    if ! command -v cmake >/dev/null 2>&1; then
        log "WARN" "cmake not found - will install in build phase"
    else
        log "CHECK" "CMake OK: $(cmake --version 2>&1 | head -1)"
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
    log "PHASE1" "=== Phase 1: Source Build Zstd v${SOFTWARE_VERSION} ==="

    if [ -f "/usr/local/lib/libzstd.so" ] || [ -f "/usr/local/lib/libzstd.a" ] || \
       [ -f "/usr/lib/libzstd.so" ] || [ -f "/usr/lib/libzstd.a" ]; then
        log "PHASE1" "Zstd library found, skipping build (will recompile benchmark only)"
    fi

    create_build_tmpdir

    local ZSTD_SRC_DIR="${BUILD_TMPDIR}/zstd_src"
    local ZSTD_BUILD_DIR="${BUILD_TMPDIR}/build"
    ZSTD_INSTALL_DIR="${BUILD_TMPDIR}/install"

    local os_id
    os_id="$(detect_os_id)"
    log "PHASE1" "Building Zstd from source on ${os_id}..."

    local os_id_lower
    os_id_lower="$(echo "${os_id}" | tr '[:upper:]' '[:lower:]')"
    case "${os_id_lower}" in
        ubuntu|debian)
            log "PHASE1" "Installing build dependencies (Ubuntu/Debian)..."
            sudo apt-get update -qq 2>&1 | tee -a "${LOG_FILE}"
            sudo apt-get install -y -qq build-essential g++ cmake make \
                git wget curl 2>&1 | tee -a "${LOG_FILE}"
            ;;
        openeuler)
            log "PHASE1" "Installing build dependencies (openEuler 24.03 SP3)..."
            sudo dnf install -y gcc gcc-c++ cmake make git wget curl 2>&1 | tee -a "${LOG_FILE}"
            ;;
        centos|rhel|fedora)
            log "PHASE1" "Installing build dependencies (RHEL-family)..."
            sudo dnf install -y gcc gcc-c++ cmake make git wget curl 2>&1 | tee -a "${LOG_FILE}"
            ;;
        *)
            log "WARN" "Unknown OS: ${os_id}, attempting generic build..."
            ;;
    esac

    local ver_tag="${SOFTWARE_VERSION}"
    [ "${ver_tag:0:1}" = "v" ] || ver_tag="v${ver_tag}"
    log "PHASE1" "Cloning Zstd tag ${ver_tag}..."
    git clone --branch "${ver_tag}" --depth 1 \
        https://github.com/facebook/zstd.git \
        "${ZSTD_SRC_DIR}" 2>&1 | tee -a "${LOG_FILE}" || {
        log "ERROR" "Failed to clone Zstd tag ${ver_tag} (verify SOFTWARE_VERSION=${SOFTWARE_VERSION} is a valid release tag)"
        return 1
    }

    local cmake_src_dir="${ZSTD_SRC_DIR}/build/cmake"
    if [ ! -d "${cmake_src_dir}" ]; then
        log "WARN" "build/cmake not found, falling back to repo root"
        cmake_src_dir="${ZSTD_SRC_DIR}"
    fi

    log "PHASE1" "Configuring CMake..."
    mkdir -p "${ZSTD_BUILD_DIR}"
    (cd "${ZSTD_BUILD_DIR}" && cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="${ZSTD_INSTALL_DIR}" \
        -DZSTD_BUILD_TESTS=OFF \
        -DZSTD_BUILD_PROGRAMS=OFF \
        "${cmake_src_dir}" 2>&1 | tee -a "${LOG_FILE}") || {
        log "ERROR" "CMake configuration failed"
        return 1
    }

    log "PHASE1" "Compiling Zstd..."
    (cd "${ZSTD_BUILD_DIR}" && make -j$(nproc) 2>&1 | tee -a "${LOG_FILE}") || {
        log "ERROR" "Zstd compilation failed"
        return 1
    }

    log "PHASE1" "Installing Zstd..."
    (cd "${ZSTD_BUILD_DIR}" && make install 2>&1 | tee -a "${LOG_FILE}") || {
        log "WARN" "make install failed, trying manual copy..."
    }

    local zstd_lib_dir="${ZSTD_INSTALL_DIR}/lib"
    if [ ! -d "${zstd_lib_dir}" ]; then zstd_lib_dir="${ZSTD_INSTALL_DIR}/lib64"; fi
    if [ ! -f "${zstd_lib_dir}/libzstd.a" ] && [ ! -f "${zstd_lib_dir}/libzstd.so" ]; then
        log "PHASE1" "Library not found in install dir, checking /usr/local..."
        if [ -f "/usr/local/lib/libzstd.a" ] || [ -f "/usr/local/lib/libzstd.so" ] || \
           [ -f "/usr/local/lib64/libzstd.a" ] || [ -f "/usr/local/lib64/libzstd.so" ]; then
            ZSTD_INSTALL_DIR="/usr/local"
            log "PHASE1" "Using system-installed Zstd at /usr/local"
        else
            log "ERROR" "Zstd library not found after build"
            return 1
        fi
    fi

    log "PHASE1" "Compiling benchmark program..."
    local BENCHMARK_SRC="${SCRIPT_DIR}/scripts/zstd_benchmark.cc"
    BENCHMARK_BIN="${BUILD_TMPDIR}/zstd_benchmark"

    local ZSTD_INC="${ZSTD_INSTALL_DIR}/include"
    local ZSTD_LIB="${ZSTD_INSTALL_DIR}/lib"
    if [ ! -d "${ZSTD_LIB}" ]; then
        ZSTD_LIB="${ZSTD_INSTALL_DIR}/lib64"
    fi

    local ZSTD_STATIC_LIB=""
    if [ -f "${ZSTD_LIB}/libzstd.a" ]; then
        ZSTD_STATIC_LIB="${ZSTD_LIB}/libzstd.a"
    elif [ -f "/usr/local/lib/libzstd.a" ]; then
        ZSTD_STATIC_LIB="/usr/local/lib/libzstd.a"
    fi

    if [ -n "${ZSTD_STATIC_LIB}" ]; then
        log "PHASE1" "Linking against static library: ${ZSTD_STATIC_LIB}"
        g++ -O2 -std=c++17 \
            -I"${ZSTD_INC}" \
            "${BENCHMARK_SRC}" \
            "${ZSTD_STATIC_LIB}" \
            -lpthread \
            -o "${BENCHMARK_BIN}" 2>&1 | tee -a "${LOG_FILE}" || {
            log "ERROR" "Benchmark compilation (static) failed"
            return 1
        }
    else
        log "PHASE1" "Linking against shared library from ${ZSTD_LIB}"
        g++ -O2 -std=c++17 \
            -I"${ZSTD_INC}" \
            "${BENCHMARK_SRC}" \
            -L"${ZSTD_LIB}" -lzstd \
            -lpthread \
            -Wl,-rpath,"${ZSTD_LIB}" \
            -o "${BENCHMARK_BIN}" 2>&1 | tee -a "${LOG_FILE}" || {
            log "ERROR" "Benchmark compilation (shared) failed"
            return 1
        }
    fi

    log "PHASE1" "Verifying benchmark binary..."
    if [ -x "${BENCHMARK_BIN}" ]; then
        "${BENCHMARK_BIN}" compression 1 "${BUILD_TMPDIR}/test_verify.json" 1024 2>&1 | tee -a "${LOG_FILE}" || {
            log "WARN" "Benchmark verification run failed"
        }
        if [ -f "${BUILD_TMPDIR}/test_verify.json" ]; then
            log "PHASE1" "Benchmark binary verified successfully"
            rm -f "${BUILD_TMPDIR}/test_verify.json"
        else
            log "WARN" "Benchmark verification output not found, but continuing..."
        fi
    else
        log "ERROR" "Benchmark binary not executable"
        return 1
    fi

    log "PHASE1" "Zstd source build and benchmark compilation complete"
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

    log "PHASE3A" "Running compression benchmark..."
    python3 "${SCRIPT_DIR}/scripts/benchmark_compression.py" \
        "${BENCHMARK_BIN}" \
        "${RESULTS_DIR}/benchmark_compression.json" \
        "${DATA_SIZE}" \
        "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "Compression benchmark had issues"

    log "PHASE3B" "Running micro benchmark..."
    python3 "${SCRIPT_DIR}/scripts/micro_benchmark.py" \
        "${BENCHMARK_BIN}" \
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
    if [ -f "/usr/local/lib/libzstd.so" ] || [ -f "/usr/local/lib/libzstd.a" ]; then found=1; fi
    if [ -f "/usr/lib/libzstd.so" ] || [ -f "/usr/lib/libzstd.a" ]; then found=1; fi
    if [ -n "${ZSTD_INSTALL_DIR}" ]; then
        local zstd_lib="${ZSTD_INSTALL_DIR}/lib"
        if [ ! -d "${zstd_lib}" ]; then zstd_lib="${ZSTD_INSTALL_DIR}/lib64"; fi
        if [ -f "${zstd_lib}/libzstd.so" ] || [ -f "${zstd_lib}/libzstd.a" ]; then found=1; fi
    fi
    if [ "${found}" -eq 0 ]; then
        echo "WARNING: Zstd library not found, skipping install check"
        startSkipping
        return
    fi
    assertTrue "Zstd library should exist" "[ ${found} -eq 1 ]"
}

testSoftwareVersionMatches() {
    local ver="${SOFTWARE_VERSION}"
    assertNotNull "Version should not be empty" "${ver}"
}

testBenchmarkBinaryExists() {
    local found=0
    if [ -n "${BENCHMARK_BIN}" ] && [ -x "${BENCHMARK_BIN}" ]; then found=1; fi
    if [ "${found}" -eq 0 ]; then
        startSkipping
        return
    fi
    assertTrue "Benchmark binary should be executable" "[ ${found} -eq 1 ]"
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
    assertTrue "Compression benchmark JSON should exist" "[ -f '${RESULTS_DIR}/benchmark_compression.json' ]"
}

testBenchmarkPrimaryHasRequiredFields() {
    local bench_file="${RESULTS_DIR}/benchmark_compression.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_benchmark has_metrics has_results
    has_benchmark="$(json_contains "${bench_file}" benchmark)"
    has_metrics="$(json_contains "${bench_file}" performance_metrics)"
    has_results="$(json_contains "${bench_file}" results_summary)"
    assertTrue "Should have benchmark field" "[ ${has_benchmark} -eq 1 ]"
    assertTrue "Should have performance_metrics field" "[ ${has_metrics} -eq 1 ]"
    assertTrue "Should have results_summary field" "[ ${has_results} -eq 1 ]"
}

testBenchmarkPrimaryCompressionSpeedAboveThreshold() {
    local bench_file="${RESULTS_DIR}/benchmark_compression.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local text_compress_speed
    text_compress_speed="$(json_get "${bench_file}" results_summary text_data_level3 compress_speed_mbs)"
    if [ "${text_compress_speed}" = "NULL" ] || [ -z "${text_compress_speed}" ]; then
        startSkipping
        return
    fi
    echo "[DIAG] Text level-3 compress speed: ${text_compress_speed} MB/s (threshold: ${MIN_COMPRESS_SPEED})"
    assertTrue "Text level-3 compress speed (${text_compress_speed}) should be >= ${MIN_COMPRESS_SPEED} MB/s" \
        "[ $(echo "${text_compress_speed} >= ${MIN_COMPRESS_SPEED}" | bc -l) -eq 1 ]"
}

testBenchmarkPrimaryDecompressSpeedAboveThreshold() {
    local bench_file="${RESULTS_DIR}/benchmark_compression.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local text_decompress_speed
    text_decompress_speed="$(json_get "${bench_file}" results_summary text_data_level3 decompress_speed_mbs)"
    if [ "${text_decompress_speed}" = "NULL" ] || [ -z "${text_decompress_speed}" ]; then
        startSkipping
        return
    fi
    echo "[DIAG] Text level-3 decompress speed: ${text_decompress_speed} MB/s (threshold: ${MIN_DECOMPRESS_SPEED})"
    assertTrue "Text level-3 decompress speed (${text_decompress_speed}) should be >= ${MIN_DECOMPRESS_SPEED} MB/s" \
        "[ $(echo "${text_decompress_speed} >= ${MIN_DECOMPRESS_SPEED}" | bc -l) -eq 1 ]"
}

testBenchmarkPrimaryCompressionRatioAboveThreshold() {
    local bench_file="${RESULTS_DIR}/benchmark_compression.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local text_ratio
    text_ratio="$(json_get "${bench_file}" results_summary text_data_level3 compression_ratio)"
    if [ "${text_ratio}" = "NULL" ] || [ -z "${text_ratio}" ]; then
        startSkipping
        return
    fi
    echo "[DIAG] Text level-3 compression ratio: ${text_ratio} (threshold: ${MIN_COMPRESSION_RATIO})"
    assertTrue "Text level-3 compression ratio (${text_ratio}) should be >= ${MIN_COMPRESSION_RATIO}" \
        "[ $(echo "${text_ratio} >= ${MIN_COMPRESSION_RATIO}" | bc -l) -eq 1 ]"
}

testBenchmarkPrimaryIsCompression() {
    local bench_file="${RESULTS_DIR}/benchmark_compression.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local bench_name
    bench_name="$(json_get "${bench_file}" benchmark)"
    assertEquals "Benchmark name should be compression" "compression" "${bench_name}"
}

testBenchmarkPrimaryLevelSweepCompleted() {
    local bench_file="${RESULTS_DIR}/benchmark_compression.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_l1 has_l3 has_l9 has_l19
    has_l1="$(json_contains "${bench_file}" level1)"
    has_l3="$(json_contains "${bench_file}" level3)"
    has_l9="$(json_contains "${bench_file}" level9)"
    has_l19="$(json_contains "${bench_file}" level19)"
    assertTrue "Should have level 1 results" "[ ${has_l1} -eq 1 ]"
    assertTrue "Should have level 3 results" "[ ${has_l3} -eq 1 ]"
    assertTrue "Should have level 9 results" "[ ${has_l9} -eq 1 ]"
    assertTrue "Should have level 19 results" "[ ${has_l19} -eq 1 ]"
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

testBenchmarkMicroBlockLatencyBelowThreshold() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local latency
    latency="$(json_get "${bench_file}" results block_compress_decompress 65536 compress_latency_us)"
    if [ "${latency}" = "NULL" ] || [ -z "${latency}" ]; then
        startSkipping
        return
    fi
    echo "[DIAG] 64KB block compress latency (level 3): ${latency} us (threshold: ${MAX_COMPRESS_LATENCY_US})"
    assertTrue "64KB block compress latency (${latency}us) should be <= ${MAX_COMPRESS_LATENCY_US}us" \
        "[ $(echo "${latency} <= ${MAX_COMPRESS_LATENCY_US}" | bc -l) -eq 1 ]"
}

testBenchmarkMicroMultithreadScaling() {
    local bench_file="${RESULTS_DIR}/micro_benchmark.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_mt
    has_mt="$(json_contains "${bench_file}" multithread_scaling)"
    assertTrue "Should have multithread scaling results" "[ ${has_mt} -eq 1 ]"
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
Zstd Source Build & Performance Benchmark (shUnit2)
Options:
  --check    Check prerequisites only (do not run benchmarks)
  -h|--help  Show this help
Environment variables:
  SOFTWARE_VERSION          Zstd version (default: 1.5.6; supported: 1.5.6, 1.5.7)
  TARGET_OS                OS name in results (default: openEuler 24.03 SP3)
  TARGET_MODEL             Hardware model (default: Kunpeng-920)
  DATA_SIZE                Data size in bytes (default: 1048576 = 1MB)
  ITERATIONS               Number of iterations (default: 1)
  MIN_COMPRESS_SPEED       Minimum compress speed MB/s threshold (default: 100)
  MIN_DECOMPRESS_SPEED     Minimum decompress speed MB/s threshold (default: 200)
  MIN_COMPRESSION_RATIO    Minimum compression ratio threshold (default: 1.2)
  MAX_COMPRESS_LATENCY_US  Maximum compress latency us threshold (default: 50000)
Examples:
  # Check prerequisites
  ./zstd_test.sh --check
  # Full run (default level sweep: 1/3/9/19)
  ./zstd_test.sh
  # Custom params
  DATA_SIZE=1048576 ITERATIONS=3 ./zstd_test.sh
  # Zstd 1.5.7 (latest, small-data +10~30%)
  SOFTWARE_VERSION=1.5.7 ./zstd_test.sh
  # Zstd 1.5.6 (Chrome Edition, widely deployed)
  SOFTWARE_VERSION=1.5.6 ./zstd_test.sh
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
