#!/bin/bash

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

SERVER_DIR="/mongoose"
SERVER_BIN="./server"
PORT=8000
WEBROOT="/mongoose/web_root"
SERVER_PID=""

cleanup() {
    if [ -n "${SERVER_PID}" ]; then
        kill "${SERVER_PID}" 2>/dev/null
        wait "${SERVER_PID}" 2>/dev/null
    fi
    if [ -n "${WEBROOT}" ] && [ -d "${WEBROOT}" ]; then
        rm -rf "${WEBROOT}"
    fi
}
trap cleanup EXIT

start_server() {
    (
        cd "${SERVER_DIR}" || exit 1
        exec "${SERVER_BIN}"
    ) >/dev/null 2>&1 &
    SERVER_PID=$!
}

http_get() {
    local path="$1"
    (
        exec 3<>"/dev/tcp/127.0.0.1/${PORT}" 2>/dev/null || exit 1
        printf 'GET %s HTTP/1.1\r\nHost: 127.0.0.1\r\nConnection: close\r\n\r\n' \
            "${path}" >&3
        cat <&3
        exec 3<&- 3>&-
    )
}

wait_ready() {
    local i=0
    while [ "${i}" -lt 30 ]; do
        if http_get "/" >/dev/null 2>&1; then
            return 0
        fi
        i=$((i + 1))
        sleep 1
    done
    return 1
}

test_version() {
    local resp reported
    resp="$(http_get "/" 2>/dev/null)" || {
        echo "FAIL: cannot fetch / to read mongoose version"
        return 1
    }
    reported="$(printf '%s\n' "${resp}" | grep -o 'Mongoose v\.[0-9][0-9.]*' | head -n1)"
    reported="${reported#Mongoose v.}"
    if [ -z "${reported}" ]; then
        echo "FAIL: no version marker in server directory listing"
        return 1
    fi
    if [ "${reported}" = "${EXPECTED_VERSION}" ]; then
        echo "PASS: exact mongoose version ${reported}"
        return 0
    fi
    echo "FAIL: version mismatch expected=${EXPECTED_VERSION} actual=${reported}"
    return 1
}

test_http_serve() {
    local resp content
    content="mongoose-serve-probe-content"
    printf '%s' "${content}" > "${WEBROOT}/probe.txt" || {
        echo "FAIL: cannot write probe file ${WEBROOT}/probe.txt"
        return 1
    }
    resp="$(http_get "/probe.txt" 2>/dev/null)" || {
        echo "FAIL: cannot fetch /probe.txt"
        return 1
    }
    if [[ "${resp}" != HTTP/1.1\ 200* ]]; then
        echo "FAIL: unexpected HTTP status: $(printf '%s\n' "${resp}" | head -n1)"
        return 1
    fi
    if [[ "${resp}" != *"${content}" ]]; then
        echo "FAIL: probe content not served back"
        return 1
    fi
    echo "PASS: static file served with correct content"
    return 0
}

main() {
    local failures=0

    mkdir -p "${WEBROOT}" || {
        echo "FATAL: cannot create web root ${WEBROOT}"
        return 1
    }
    start_server
    if ! wait_ready; then
        echo "FATAL: server did not become ready within 30s"
        return 1
    fi

    test_version || failures=$((failures + 1))
    test_http_serve || failures=$((failures + 1))

    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        return 0
    fi
    echo "TESTS_FAILED: ${failures} failure(s)"
    return 1
}

main "$@"
