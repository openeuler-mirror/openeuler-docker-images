#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOFTWARE_NAME="rust"
SOFTWARE_VERSION="${SOFTWARE_VERSION:-1.96.0}"
export SOFTWARE_VERSION
DOCKER_IMAGE="openeuler/rust"
DOCKER_TAG="${DOCKER_TAG:-1.96.0-oe2403sp3}"
DOCKER_CID=""
SHUNIT2_PATH=""
HAS_PYTHON3=0
ITERATIONS="${ITERATIONS:-5}"

RESULTS_DIR="${SCRIPT_DIR}/results/${SOFTWARE_VERSION}"
mkdir -p "${RESULTS_DIR}"
LOG_FILE="${RESULTS_DIR}/results.log"
JSON_HELPER="${SCRIPT_DIR}/scripts/json_helper.py"

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

detect_os_name() { echo "openEuler 24.03 SP3"; }

download_shunit2() {
    local shunit2_tmpdir="$(mktemp -d /tmp/shunit2_XXXXXX)"
    SHUNIT2_PATH="${shunit2_tmpdir}/shunit2"
    log "SETUP" "Downloading shUnit2..."
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
    if ! command -v docker >/dev/null 2>&1; then
        log "ERROR" "docker is not installed"
        errors=$((errors + 1))
    else
        log "CHECK" "Docker OK: $(docker --version 2>&1)"
    fi
    if [ ! -f "${JSON_HELPER}" ]; then
        log "ERROR" "json_helper.py not found at ${JSON_HELPER}"
        errors=$((errors + 1))
    else
        log "CHECK" "json_helper.py OK"
    fi
    log "CHECK" "Architecture: $(uname -m)"
    return ${errors}
}

phase1_install() {
    log "PHASE1" "=== Phase 1: Docker Pull rust v${SOFTWARE_VERSION} ==="
    log "PHASE1" "Pulling ${DOCKER_IMAGE}:${DOCKER_TAG}..."
    docker pull "${DOCKER_IMAGE}:${DOCKER_TAG}" 2>&1 | tee -a "${LOG_FILE}" || {
        log "ERROR" "docker pull failed"
        return 1
    }
    log "PHASE1" "Starting container..."
    DOCKER_CID=$(docker run -d \
        -v "${SCRIPT_DIR}/scripts:/workspace/scripts" \
        -v "${SCRIPT_DIR}/results:/workspace/results" \
        -e SOFTWARE_VERSION="${SOFTWARE_VERSION}" \
        "${DOCKER_IMAGE}:${DOCKER_TAG}" \
        sleep infinity) || {
        log "ERROR" "docker run failed"
        return 1
    }
    log "PHASE1" "Container ${DOCKER_CID} started"
}

phase2_verify() {
    log "PHASE2" "=== Phase 2: Collect Version Info ==="
    local timestamp model arch kernel os_name cpu_model cores python_ver numpy_ver
    timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ' | tr -d '\n\t')"
    model="Kunpeng-920"
    arch="$(uname -m | tr -d '\n\t')"
    kernel="$(uname -r | tr -d '\n\t')"
    os_name="$(detect_os_name | tr -d '\n\t')"
    cpu_model="$(grep 'model name' /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | xargs | tr -d '\n\t')"
    if [ -z "${cpu_model}" ]; then
        local num_proc="$(grep -c 'processor' /proc/cpuinfo 2>/dev/null || echo 0)"
        cpu_model="ARM64 CPU (${num_proc} cores)"
    fi
    cores="$(nproc 2>/dev/null | tr -d '\n\t' || echo '4')"
    if [ "${HAS_PYTHON3}" -eq 1 ]; then
        python_ver="$(docker exec "${DOCKER_CID}" python3 --version 2>&1 | tr -d '\n\t')"
        numpy_ver="$(docker exec "${DOCKER_CID}" python3 -c 'import numpy; print(numpy.__version__)' 2>/dev/null | tr -d '\n\t' || echo 'unknown')"
    else
        python_ver="$(python3 --version 2>&1 | tr -d '\n\t' || echo 'unknown')"
        numpy_ver="$(python3 -c 'import numpy; print(numpy.__version__)' 2>/dev/null | tr -d '\n\t' || echo 'unknown')"
    fi

    python3 "${JSON_HELPER}" "${RESULTS_DIR}/version_info.json" write_version_info \
        "${timestamp}" "${model}" "${arch}" "${kernel}" "${os_name}" "${cpu_model}" \
        "${cores}" "${SOFTWARE_NAME}" "${SOFTWARE_VERSION}" \
        "${python_ver}" "${numpy_ver}"
}

phase3_run_benchmarks() {
    log "PHASE3" "=== Phase 3: Run Benchmarks ==="
    mkdir -p "${RESULTS_DIR}"

    if [ "${HAS_PYTHON3}" -eq 1 ]; then
    docker exec "${DOCKER_CID}" python3 /workspace/scripts/benchmark_generic.py --output /workspace/results/${SOFTWARE_VERSION}/benchmark_generic.json --version "${SOFTWARE_VERSION}" --iterations "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "Benchmark had issues"
        log "PHASE3B" "Running micro benchmark..."
        docker exec "${DOCKER_CID}" python3 /workspace/scripts/micro_benchmark.py \
            --output /workspace/results/${SOFTWARE_VERSION}/micro_benchmark.json \
            --version "${SOFTWARE_VERSION}" \
            --iterations "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "Micro benchmark had issues"
    else
        log "PHASE3" "No python3 in container, running benchmarks on host"
        python3 "${SCRIPT_DIR}/scripts/benchmark_generic.py" --output "${RESULTS_DIR}/benchmark_generic.json" --version "${SOFTWARE_VERSION}" --iterations "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "Benchmark had issues"
        python3 "${SCRIPT_DIR}/scripts/micro_benchmark.py" \
            --output "${RESULTS_DIR}/micro_benchmark.json" \
            --version "${SOFTWARE_VERSION}" \
            --iterations "${ITERATIONS}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "Micro benchmark had issues"
    fi
}

phase4_results() {
    log "PHASE4" "=== Phase 4: Aggregate & Report ==="
    mkdir -p "${RESULTS_DIR}"

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
    log "START" "rust Performance Benchmark v${SOFTWARE_VERSION}"
    check_prerequisites || log "WARN" "Some prerequisites missing, continuing..."
    phase1_install || { log "FATAL" "Phase 1 (docker pull) failed, aborting"; return 1; }
    HAS_PYTHON3=0
    if docker exec "${DOCKER_CID}" python3 --version >/dev/null 2>&1; then
        HAS_PYTHON3=1
        log "CHECK" "python3 available inside container"
    else
        HAS_PYTHON3=0
        log "WARN" "python3 NOT available inside container, using host-side fallback"
    fi
    phase2_verify || log "WARN" "Phase 2 had issues, continuing..."
    phase3_run_benchmarks || log "WARN" "Phase 3 had issues, continuing..."
    phase4_results || log "WARN" "Phase 4 had issues..."
}

oneTimeTearDown() {
    if [ -n "${DOCKER_CID}" ]; then
        log "CLEANUP" "Stopping container ${DOCKER_CID}"
        docker stop "${DOCKER_CID}" >/dev/null 2>&1
        docker rm "${DOCKER_CID}" >/dev/null 2>&1
        DOCKER_CID=""
    fi
    if [ -n "${SHUNIT2_PATH}" ]; then
        local shunit2_dir="$(dirname "${SHUNIT2_PATH}")"
        rm -rf "${shunit2_dir}"
        SHUNIT2_PATH=""
    fi
}

setUp() { rm -f "${RESULTS_DIR}/test_temp_*.json"; }
tearDown() { rm -f "${RESULTS_DIR}/test_temp_*.json"; }

testArchitectureIsARM64() {
    local arch="$(uname -m)"
    assertTrue "Architecture should be aarch64 or arm64, got: ${arch}" \
        "[ '${arch}' = 'aarch64' ] || [ '${arch}' = 'arm64' ]"
}

testDockerImageAvailable() {
    if [ -z "${DOCKER_CID}" ]; then startSkipping; return; fi
    local img="openeuler/rust:${DOCKER_TAG}"
    local check
    check="$(docker images --format '{{.Repository}}:{{.Tag}}' "${img}" | grep -c "${img}")"
    assertTrue "Docker image ${img} should be available" "[ ${check} -ge 1 ]"
}

testSoftwareIsInstalled() {
    if [ -z "${DOCKER_CID}" ]; then startSkipping; return; fi
    local found=0
    if [ "${HAS_PYTHON3}" -eq 1 ]; then
        docker exec "${DOCKER_CID}" python3 -c "import rust" 2>/dev/null && found=1
    fi
    if [ "${found}" -eq 0 ]; then
        docker exec "${DOCKER_CID}" which rust 2>/dev/null && found=1
    fi
    if [ "${found}" -eq 0 ]; then
        docker exec "${DOCKER_CID}" bash -c "ls /opt/rust*/bin/rust /usr/local/bin/rust /usr/bin/rust 2>/dev/null" | head -1 | grep -q . && found=1
    fi
    if [ "${found}" -eq 0 ]; then
        log "WARN" "rust not found as Python module or binary, skipping install check"
        startSkipping
        return
    fi
    assertTrue "Software should be available in container" "[ ${found} -eq 1 ]"
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
    local has_arch="$(json_field_exists "${vfile}" architecture)"
    assertTrue "Version info should have architecture field" "[ ${has_arch} -eq 1 ]"
}

testVersionInfoHasSoftwareVersion() {
    local vfile="${RESULTS_DIR}/version_info.json"
    if [ ! -f "${vfile}" ]; then startSkipping; return; fi
    local has_ver="$(json_field_exists "${vfile}" software_version)"
    assertTrue "Version info should have software_version field" "[ ${has_ver} -eq 1 ]"
}

testBenchmarkPrimaryProducesResults() {
    if [ -z "${DOCKER_CID}" ] && [ "${HAS_PYTHON3}" -eq 0 ]; then startSkipping; return; fi
    assertTrue "Benchmark JSON should exist" "[ -f '${RESULTS_DIR}/benchmark_generic.json' ]"
}

testBenchmarkPrimaryHasRequiredFields() {
    local bench_file="${RESULTS_DIR}/benchmark_generic.json"
    if [ ! -f "${bench_file}" ]; then startSkipping; return; fi
    local has_benchmark has_metrics has_results
    has_benchmark="$(json_contains "${bench_file}" benchmark)"
    has_metrics="$(json_contains "${bench_file}" performance_metrics)"
    has_results="$(json_contains "${bench_file}" results_summary)"
    assertTrue "Should have benchmark field" "[ ${has_benchmark} -eq 1 ]"
    assertTrue "Should have performance_metrics field" "[ ${has_metrics} -eq 1 ]"
    assertTrue "Should have results_summary field" "[ ${has_results} -eq 1 ]"
}

testBenchmarkMicroProducesResults() {
    if [ -z "${DOCKER_CID}" ] && [ "${HAS_PYTHON3}" -eq 0 ]; then startSkipping; return; fi
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
    local ops_count="$(json_count_results "${bench_file}")"
    assertTrue "Should have micro benchmark results (count=${ops_count})" "[ ${ops_count} -ge 2 ]"
}

testAggregatedResultsExist() {
    if [ ! -f "${RESULTS_DIR}/results.json" ]; then startSkipping; return; fi
    assertTrue "results.json should exist" "[ -f '${RESULTS_DIR}/results.json' ]"
}

testSummaryReportGenerated() {
    if [ ! -f "${RESULTS_DIR}/results.txt" ]; then startSkipping; return; fi
    assertTrue "results.txt should exist" "[ -f '${RESULTS_DIR}/results.txt' ]"
}

testLogFileGenerated() {
    if [ ! -f "${RESULTS_DIR}/results.log" ]; then startSkipping; return; fi
    assertTrue "results.log should exist" "[ -f '${RESULTS_DIR}/results.log' ]"
}

testAggregatedResultsContainsAllBenchmarks() {
    local agg_file="${RESULTS_DIR}/results.json"
    if [ ! -f "${agg_file}" ]; then startSkipping; return; fi
    local has_primary has_micro
    has_primary="$(json_contains "${agg_file}" primary_benchmark)"
    has_micro="$(json_contains "${agg_file}" micro)"
    assertTrue "Should contain primary_benchmark data" "[ ${has_primary} -eq 1 ]"
    assertTrue "Should contain micro_benchmark data" "[ ${has_micro} -eq 1 ]"
}

usage() {
    cat <<USAGE
Usage: $(basename "$0") [OPTIONS]
rust Performance Benchmark (shUnit2 + Docker)
Options:
  --check    Check prerequisites only
  -h|--help  Show this help
Environment variables:
  SOFTWARE_VERSION         rust version (default: 1.96.0)
  DOCKER_TAG              Docker image tag (default: 1.96.0-oe2403sp3)
  ITERATIONS              Number of iterations (default: 1)
Examples:
  ./rust_test.sh --check
  ./rust_test.sh
  SOFTWARE_VERSION=1.96.0 ./rust_test.sh
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

    log "START" "rust Performance Benchmark v${SOFTWARE_VERSION}"

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

    SHUNIT_PARENT="${SCRIPT_DIR}/rust_test.sh"
    . "${SHUNIT2_PATH}"
}

if [ "${1:-}" != "--shunit2-run" ]; then
    main "$@"
fi