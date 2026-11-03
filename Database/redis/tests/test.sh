#!/bin/bash
set -e; set -o pipefail

BINARY="redis-server"
CLI="redis-cli"
PORT=6379
DATA_DIR="/data"
PIDFILE="/data/redis-test.pid"
LOG_FILE="/tmp/redis-test.log"
STARTED_VIA_GOSU=0
: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

redis_ping() {
    "${CLI}" -h 127.0.0.1 -p "${PORT}" PING 2>/dev/null
}

wait_for_redis() {
    local timeout=60
    local i
    for ((i = 1; i <= timeout; i++)); do
        if [ "$(redis_ping)" = "PONG" ]; then
            echo "INFO: redis is ready on tcp/${PORT} after ${i}s"
            return 0
        fi
        sleep 1
    done
    echo "ERROR: redis did not answer PING on tcp/${PORT} within ${timeout}s"
    redis_ping 2>&1 || true
    return 1
}

# The image's ENTRYPOINT normally drops privileges via gosu; the test runner
# overrides it with bash, so start the server here and mirror that behaviour.
start_server() {
    echo "INFO: starting redis-server ..."
    local server_args=(
        --port "${PORT}"
        --bind 127.0.0.1
        --dir "${DATA_DIR}"
        --pidfile "${PIDFILE}"
        --daemonize no
        --protected-mode no
    )
    if [ "$(id -u)" = "0" ] && command -v gosu >/dev/null 2>&1; then
        STARTED_VIA_GOSU=1
        gosu redis "${BINARY}" "${server_args[@]}" >"${LOG_FILE}" 2>&1 &
    else
        "${BINARY}" "${server_args[@]}" >"${LOG_FILE}" 2>&1 &
    fi
    wait_for_redis
}

stop_server() {
    echo "INFO: stopping redis-server ..."
    "${CLI}" -h 127.0.0.1 -p "${PORT}" SHUTDOWN NOSAVE >/dev/null 2>&1 || true
    local pid
    pid="$(cat "${PIDFILE}" 2>/dev/null || true)"
    if [ -n "${pid}" ] && kill -0 "${pid}" 2>/dev/null; then
        kill "${pid}" 2>/dev/null || true
    fi
    rm -f "${PIDFILE}" 2>/dev/null || true
}

trap 'stop_server' EXIT

test_binary_exists() {
    if command -v "${BINARY}" >/dev/null 2>&1 && command -v "${CLI}" >/dev/null 2>&1; then
        echo "PASS: binaries ${BINARY} and ${CLI} exist"
        return 0
    fi
    echo "FAIL: ${BINARY} or ${CLI} not found in PATH"
    return 1
}

test_version() {
    local output reported=""
    output="$("${BINARY}" --version 2>&1 || true)"
    if [[ "${output}" =~ ^Redis\ server\ v=([^[:space:]]+) ]]; then
        reported="${BASH_REMATCH[1]}"
    fi
    if [ "${reported}" = "${EXPECTED_VERSION}" ]; then
        echo "PASS: exact version check - ${reported}"
        return 0
    fi
    echo "FAIL: exact version check - expected 'v=${EXPECTED_VERSION}', got '${output}'"
    return 1
}

test_ping() {
    local res
    res="$(redis_ping || true)"
    if [ "${res}" = "PONG" ]; then
        echo "PASS: redis-cli PING returns PONG"
        return 0
    fi
    echo "FAIL: redis-cli PING returned '${res}', expected 'PONG'"
    return 1
}

test_set_get() {
    local key value set_res get_res
    key="redis:test:$$:$(date +%s)"
    value="openeuler-redis-value"
    set_res="$("${CLI}" -h 127.0.0.1 -p "${PORT}" SET "${key}" "${value}" 2>/dev/null || true)"
    if [ "${set_res}" != "OK" ]; then
        echo "FAIL: redis-cli SET returned '${set_res}', expected 'OK'"
        return 1
    fi
    get_res="$("${CLI}" -h 127.0.0.1 -p "${PORT}" GET "${key}" 2>/dev/null || true)"
    if [ "${get_res}" != "${value}" ]; then
        echo "FAIL: redis-cli GET returned '${get_res}', expected '${value}'"
        return 1
    fi
    echo "PASS: SET/GET round-trip through redis protocol"
    return 0
}

test_run_identity() {
    local pid uid ok=1 detail=""
    pid="$(cat "${PIDFILE}" 2>/dev/null || true)"
    if [ -z "${pid}" ]; then
        echo "FAIL: pidfile ${PIDFILE} missing or empty"
        return 1
    fi
    if [ -r "/proc/${pid}/status" ]; then
        uid="$(grep '^Uid:' "/proc/${pid}/status" | cut -f2)"
        if [ "${STARTED_VIA_GOSU}" = "1" ]; then
            if [ -n "${uid}" ] && [ "${uid}" != "0" ]; then
                detail="non-root uid ${uid}"
            else
                detail="running as root uid '${uid}'"
                ok=0
            fi
        else
            detail="uid check skipped (gosu unavailable)"
        fi
    else
        detail="cannot read /proc/${pid}/status; uid check skipped"
    fi
    if [ -w "${DATA_DIR}" ]; then
        detail="${detail}; data dir writable"
    else
        detail="${detail}; data dir NOT writable"
        ok=0
    fi
    if [ "${ok}" -eq 1 ]; then
        echo "PASS: ${detail}"
    else
        echo "FAIL: ${detail}"
    fi
    return $((1 - ok))
}

main() {
    local failures=0
    start_server || failures=$((failures + 1))
    test_binary_exists || failures=$((failures + 1))
    test_version || failures=$((failures + 1))
    test_ping || failures=$((failures + 1))
    test_set_get || failures=$((failures + 1))
    test_run_identity || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        exit 0
    fi
    echo "TESTS_FAILED: ${failures} failures"
    exit 1
}
main "$@"
