#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOFTWARE_NAME="mysql"
SOFTWARE_VERSION="${SOFTWARE_VERSION:-8.0}"
export SOFTWARE_VERSION
BUILD_METHOD="deploy"
TARGET_OS="${TARGET_OS:-openEuler 24.03 SP3}"
TARGET_MODEL="${TARGET_MODEL:-Kunpeng-920}"
RESULTS_DIR="${SCRIPT_DIR}/results/${SOFTWARE_VERSION}"
mkdir -p "${RESULTS_DIR}"
LOG_FILE="${RESULTS_DIR}/results.log"
JSON_HELPER="${SCRIPT_DIR}/scripts/json_helper.py"
SHUNIT2_PATH=""
MYSQL_RUNNING=0
MYSQL_HOST="${MYSQL_HOST:-127.0.0.1}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MYSQL_USER="${MYSQL_USER:-root}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-}"
MYSQL_DB="${MYSQL_DB:-sbtest}"
TABLES="${TABLES:-4}"
TABLE_SIZE="${TABLE_SIZE:-10000}"
TIME_PER_TEST="${TIME_PER_TEST:-60}"
ITERATIONS="${ITERATIONS:-1}"
MINIMUM_TPS="${MINIMUM_TPS:-10}"
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
    command -v mysql >/dev/null 2>&1 && log "CHECK" "MySQL client OK" || log "WARN" "mysql not found"
    command -v sysbench >/dev/null 2>&1 && log "CHECK" "sysbench OK: $(sysbench --version 2>&1)" || log "WARN" "sysbench not found"
    [ -f "${JSON_HELPER}" ] && log "CHECK" "json_helper.py OK" || { log "ERROR" "json_helper.py not found"; err=$((err+1)); }
    local os_id; os_id="$(detect_os_id)"
    local os_id_lower; os_id_lower="$(echo "${os_id}" | tr '[:upper:]' '[:lower:]')"
    log "CHECK" "OS: $(detect_os_name) (${os_id})"
    log "CHECK" "Architecture: $(uname -m)"
    log "CHECK" "Build method: ${BUILD_METHOD} (dnf install, NOT source build)"
    local mem_mb; mem_mb="$(free -m 2>/dev/null | awk '/^Mem:/ {print $2}' || echo 0)"
    if [ "${mem_mb}" -gt 0 ] && [ "${mem_mb}" -lt 2048 ]; then log "WARN" "Memory ${mem_mb}MB low, MySQL needs ~2GB"; fi
    case "${os_id_lower}" in
        ubuntu|debian) sudo apt-get update -qq >/dev/null 2>&1; sudo apt-get install -y -qq mysql-client sysbench >/dev/null 2>&1 ;;
        openeuler) sudo dnf install -y mysql sysbench 2>/dev/null; [ $? -ne 0 ] && sudo dnf install -y community-mysql sysbench 2>/dev/null ;;
        centos|rhel|fedora) sudo dnf install -y mysql sysbench 2>/dev/null; [ $? -ne 0 ] && sudo dnf install -y community-mysql sysbench 2>/dev/null ;;
        *) log "WARN" "Unknown OS: ${os_id}" ;;
    esac
    return ${err}
}
check_mysql_running() {
    local cmd="mysql -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER}"
    [ -n "${MYSQL_PASSWORD}" ] && cmd="${cmd} -p${MYSQL_PASSWORD}"
    ${cmd} -e "SELECT 1" >/dev/null 2>&1
}
phase1_deploy() {
    log "PHASE1" "=== Phase 1: Verify/deploy MySQL ==="
    log "PHASE1" "Checking MySQL at ${MYSQL_HOST}:${MYSQL_PORT}..."
    if check_mysql_running; then
        log "PHASE1" "MySQL already running"
        MYSQL_RUNNING=1
        return 0
    fi
    log "PHASE1" "MySQL not running, trying to start..."
    local os_id; os_id="$(detect_os_id)"
    local os_id_lower; os_id_lower="$(echo "${os_id}" | tr '[:upper:]' '[:lower:]')"
    case "${os_id_lower}" in
        ubuntu|debian) sudo apt-get install -y -qq mysql-server >/dev/null 2>&1; sudo systemctl start mysql 2>/dev/null || sudo service mysql start 2>/dev/null ;;
        openeuler|centos|rhel|fedora) sudo dnf install -y mysql-server 2>/dev/null || sudo dnf install -y community-mysql-server 2>/dev/null; sudo systemctl start mysqld 2>/dev/null || sudo systemctl start mariadb 2>/dev/null ;;
    esac
    log "PHASE1" "Waiting for MySQL to be ready..."
    local retries=0
    while [ "${retries}" -lt 30 ]; do
        if check_mysql_running; then
            log "PHASE1" "MySQL ready (after ${retries} retries)"
            MYSQL_RUNNING=1
            return 0
        fi
        retries=$((retries + 1))
        sleep 2
    done
    log "ERROR" "MySQL did not become ready. Please install+start MySQL manually: sudo dnf install mysql-server && sudo systemctl start mysqld"
    return 1
}
phase2_verify() {
    log "PHASE2" "=== Phase 2: Collect Version Info ==="
    local timestamp model arch kernel os_name cpu_model cores python_ver sysbench_ver
    timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ' | tr -d '\n\t')"
    model="${TARGET_MODEL}"; arch="$(uname -m | tr -d '\n\t')"; kernel="$(uname -r | tr -d '\n\t')"
    os_name="$(detect_os_name | tr -d '\n\t')"
    cpu_model="$(grep 'model name' /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | xargs | tr -d '\n\t')"
    if [ -z "${cpu_model}" ]; then local np; np="$(grep -c 'processor' /proc/cpuinfo 2>/dev/null || echo 0)"; cpu_model="ARM64 CPU (${np} cores)"; fi
    cores="$(nproc 2>/dev/null | tr -d '\n\t' || echo '4')"
    python_ver="$(python3 --version 2>&1 | tr -d '\n\t')"
    sysbench_ver="$(sysbench --version 2>&1 | tr -d '\n\t' || echo 'unknown')"
    local mysql_ver="${SOFTWARE_VERSION}"
    if check_mysql_running; then
        local mcmd="mysql -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER}"
        [ -n "${MYSQL_PASSWORD}" ] && mcmd="${mcmd} -p${MYSQL_PASSWORD}"
        mysql_ver="$(${mcmd} -e 'SELECT version()' -s -N 2>/dev/null | tr -d '\n\t' || echo "${SOFTWARE_VERSION}")"
    fi
    python3 "${JSON_HELPER}" "${RESULTS_DIR}/version_info.json" write_version_info \
        "${timestamp}" "${model}" "${arch}" "${kernel}" "${os_name}" "${cpu_model}" \
        "${cores}" "${SOFTWARE_NAME}" "${mysql_ver}" "${python_ver}" "${sysbench_ver}"
    log "PHASE2" "Version info saved (MySQL: ${mysql_ver}, sysbench: ${sysbench_ver})"
}
phase3_run_benchmarks() {
    log "PHASE3" "=== Phase 3: Run Benchmarks ==="
    mkdir -p "${RESULTS_DIR}"
    if [ "${MYSQL_RUNNING}" -eq 0 ]; then log "ERROR" "MySQL not running, skipping"; return 1; fi
    log "PHASE3A" "Running OLTP benchmark (sysbench)..."
    python3 "${SCRIPT_DIR}/scripts/benchmark_mysql.py" \
        "${RESULTS_DIR}/benchmark_mysql.json" \
        "${MYSQL_HOST}" "${MYSQL_PORT}" "${MYSQL_USER}" "${MYSQL_PASSWORD}" "${MYSQL_DB}" \
        "${TABLES}" "${TABLE_SIZE}" "${ITERATIONS}" "${TIME_PER_TEST}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "OLTP benchmark had issues"
    log "PHASE3B" "Running micro benchmark..."
    python3 "${SCRIPT_DIR}/scripts/micro_benchmark.py" \
        "${RESULTS_DIR}/micro_benchmark.json" \
        "${MYSQL_HOST}" "${MYSQL_PORT}" "${MYSQL_USER}" "${MYSQL_PASSWORD}" \
        "${TABLES}" "${TABLE_SIZE}" "${ITERATIONS}" "${TIME_PER_TEST}" 2>&1 | tee -a "${LOG_FILE}" || log "WARN" "Micro benchmark had issues"
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
    phase1_deploy || log "FATAL" "Phase 1 failed"
    phase2_verify || log "WARN" "Phase 2 had issues"
    phase3_run_benchmarks || log "WARN" "Phase 3 had issues"
    phase4_results || log "WARN" "Phase 4 had issues"
}
oneTimeTearDown() { if [ -n "${SHUNIT2_PATH}" ]; then rm -rf "$(dirname "${SHUNIT2_PATH}")"; SHUNIT2_PATH=""; fi; }
setUp() { rm -f "${RESULTS_DIR}/test_temp_*.json"; }
tearDown() { rm -f "${RESULTS_DIR}/test_temp_*.json"; }
testArchitectureIsARM64() { local a; a="$(uname -m)"; assertTrue "Arch aarch64/arm64, got ${a}" "[ '${a}' = 'aarch64' ] || [ '${a}' = 'arm64' ]"; }
testSoftwareIsInstalled() { if [ "${MYSQL_RUNNING}" -eq 0 ]; then startSkipping; return; fi; assertTrue "MySQL running" "[ ${MYSQL_RUNNING} -eq 1 ]"; }
testSoftwareVersionMatches() { assertNotNull "Version not empty" "${SOFTWARE_VERSION}"; }
testVersionInfoExists() { assertTrue "version_info.json exists" "[ -f '${RESULTS_DIR}/version_info.json' ]"; }
testVersionInfoHasArchitecture() { local vf="${RESULTS_DIR}/version_info.json"; [ -f "${vf}" ] || { startSkipping; return; }; assertTrue "has architecture" "[ $(json_field_exists "${vf}" architecture) -eq 1 ]"; }
testVersionInfoHasSoftwareVersion() { local vf="${RESULTS_DIR}/version_info.json"; [ -f "${vf}" ] || { startSkipping; return; }; assertTrue "has software_version" "[ $(json_field_exists "${vf}" software_version) -eq 1 ]"; }
testBenchmarkPrimaryProducesResults() { assertTrue "benchmark_mysql.json exists" "[ -f '${RESULTS_DIR}/benchmark_mysql.json' ]"; }
testBenchmarkPrimaryHasRequiredFields() { local bf="${RESULTS_DIR}/benchmark_mysql.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has benchmark" "[ $(json_contains "${bf}" benchmark) -eq 1 ]"; assertTrue "has performance_metrics" "[ $(json_contains "${bf}" performance_metrics) -eq 1 ]"; assertTrue "has results_summary" "[ $(json_contains "${bf}" results_summary) -eq 1 ]"; }
testBenchmarkPrimaryTpsAboveThreshold() { local bf="${RESULTS_DIR}/benchmark_mysql.json"; [ -f "${bf}" ] || { startSkipping; return; }; local tps; tps="$(json_get "${bf}" results_summary oltp_read_write threads_16 tps)"; if [ "${tps}" = "NULL" ] || [ -z "${tps}" ]; then startSkipping; return; fi; echo "[DIAG] read_write TPS t=16: ${tps} (min: ${MINIMUM_TPS})"; assertTrue "TPS >= ${MINIMUM_TPS}" "[ $(echo "${tps} >= ${MINIMUM_TPS}" | bc -l) -eq 1 ]"; }
testBenchmarkPrimaryIsOtp() { local bf="${RESULTS_DIR}/benchmark_mysql.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertEquals "benchmark is oltp" "oltp" "$(json_get "${bf}" benchmark)"; }
testBenchmarkPrimaryWorkloadsCompleted() { local bf="${RESULTS_DIR}/benchmark_mysql.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has oltp_point_select" "[ $(json_contains "${bf}" oltp_point_select) -eq 1 ]"; assertTrue "has oltp_read_write" "[ $(json_contains "${bf}" oltp_read_write) -eq 1 ]"; }
testBenchmarkMicroProducesResults() { assertTrue "micro_benchmark.json exists" "[ -f '${RESULTS_DIR}/micro_benchmark.json' ]"; }
testBenchmarkMicroHasRequiredFields() { local bf="${RESULTS_DIR}/micro_benchmark.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has benchmark" "[ $(json_contains "${bf}" benchmark) -eq 1 ]"; assertTrue "has results" "[ $(json_contains "${bf}" results) -eq 1 ]"; }
testBenchmarkMicroThreadScaling() { local bf="${RESULTS_DIR}/micro_benchmark.json"; [ -f "${bf}" ] || { startSkipping; return; }; assertTrue "has thread_scaling" "[ $(json_contains "${bf}" thread_scaling) -eq 1 ]"; }
testAggregatedResultsExist() { assertTrue "results.json exists" "[ -f '${RESULTS_DIR}/results.json' ]"; }
testSummaryReportGenerated() { assertTrue "results.txt exists" "[ -f '${RESULTS_DIR}/results.txt' ]"; }
testLogFileGenerated() { assertTrue "results.log exists" "[ -f '${RESULTS_DIR}/results.log' ]"; }
testAggregatedResultsContainsAllBenchmarks() { local af="${RESULTS_DIR}/results.json"; [ -f "${af}" ] || { startSkipping; return; }; assertTrue "has primary" "[ $(json_contains "${af}" primary) -eq 1 ]"; assertTrue "has micro" "[ $(json_contains "${af}" micro) -eq 1 ]"; }
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "MySQL Performance Benchmark (deploy variant, sysbench)"
    echo "Options: --check, -h|--help"
    echo "Env: SOFTWARE_VERSION (default: 8.0), MYSQL_HOST (127.0.0.1), MYSQL_PORT (3306)"
    echo "      MYSQL_USER (root), MYSQL_PASSWORD, MYSQL_DB (sbtest)"
    echo "      TABLES (4), TABLE_SIZE (10000), TIME_PER_TEST (60), ITERATIONS (1)"
    echo "      MINIMUM_TPS (10)"
    echo "Note: MySQL must be running or installable via dnf. Source build NOT used (hours)."
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
