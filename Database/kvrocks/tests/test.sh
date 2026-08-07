#!/bin/bash
set -e; set -o pipefail

BINARY="kvrocks"
PORT=6666
PIDFILE="/var/run/kvrocks/kvrocks.pid"
DATA_DIR="/var/lib/kvrocks"
: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

kvrocks_ping() {
    redis-cli -p "${PORT}" PING 2>/dev/null
}

wait_for_kvrocks() {
    local timeout=60
    local i
    for ((i = 1; i <= timeout; i++)); do
        if [ "$(kvrocks_ping)" = "PONG" ]; then
            echo "PASS: kvrocks is ready on tcp/${PORT} after ${i}s"
            return 0
        fi
        sleep 1
    done
    echo "FAIL: kvrocks did not answer PING on tcp/${PORT} within ${timeout}s"
    redis-cli -p "${PORT}" PING 2>&1 || true
    return 1
}

test_binary_exists() {
    if command -v "${BINARY}" >/dev/null 2>&1; then
        echo "PASS: binary ${BINARY} exists"
        return 0
    fi
    echo "FAIL: binary ${BINARY} not found in PATH"
    return 1
}

test_version() {
    local output escaped
    output="$("${BINARY}" --version 2>&1 || true)"
    escaped="${EXPECTED_VERSION//./\.}"
    if [[ "${output}" =~ ^kvrocks\ version\ ${escaped}$ ]] ||
       [[ "${output}" =~ ^kvrocks\ version\ ${escaped}\ \(commit\ [0-9a-fA-F]+\)$ ]]; then
        echo "PASS: exact version check - ${output}"
        return 0
    fi
    echo "FAIL: exact version check - expected 'kvrocks version ${EXPECTED_VERSION}', got '${output}'"
    return 1
}

test_ping() {
    local res
    res="$(kvrocks_ping || true)"
    if [ "${res}" = "PONG" ]; then
        echo "PASS: redis-cli PING returns PONG"
        return 0
    fi
    echo "FAIL: redis-cli PING returned '${res}', expected 'PONG'"
    return 1
}

test_set_get() {
    local key value set_res get_res
    key="kvrocks:test:$$:$(date +%s)"
    value="openeuler-kvrocks-value"
    set_res="$(redis-cli -p "${PORT}" SET "${key}" "${value}" 2>/dev/null || true)"
    if [ "${set_res}" != "OK" ]; then
        echo "FAIL: redis-cli SET returned '${set_res}', expected 'OK'"
        return 1
    fi
    get_res="$(redis-cli -p "${PORT}" GET "${key}" 2>/dev/null || true)"
    if [ "${get_res}" != "${value}" ]; then
        echo "FAIL: redis-cli GET returned '${get_res}', expected '${value}'"
        return 1
    fi
    echo "PASS: SET/GET round-trip through redis protocol"
    return 0
}

test_run_identity() {
    local pid uid ok=1
    pid="$(cat "${PIDFILE}" 2>/dev/null || true)"
    if [ -z "${pid}" ]; then
        echo "FAIL: pidfile ${PIDFILE} missing or empty"
        return 1
    fi
    if [ -r "/proc/${pid}/status" ]; then
        uid="$(grep '^Uid:' "/proc/${pid}/status" | cut -f2)"
        if [ -n "${uid}" ] && [ "${uid}" != "0" ]; then
            echo "PASS: kvrocks server runs as non-root (uid ${uid})"
        else
            echo "FAIL: kvrocks server is running as root (uid '${uid}')"
            ok=0
        fi
    else
        echo "WARN: cannot read /proc/${pid}/status; skipping uid check"
    fi
    if [ -w "${DATA_DIR}" ]; then
        echo "PASS: data dir ${DATA_DIR} is writable"
    else
        echo "FAIL: data dir ${DATA_DIR} is not writable"
        ok=0
    fi
    return $((1 - ok))
}

main() {
    local failures=0
    wait_for_kvrocks || failures=$((failures + 1))
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
