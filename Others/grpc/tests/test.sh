#!/bin/bash
# KunpengTest functional test for grpc.
#
# The image builds the upstream gRPC C++ core from github.com/grpc/grpc and
# ships the hello-world binaries (greeter_server / greeter_client) in
# /usr/local/bin, plus the upstream version header kept for assertion.
# CI executes this script with `--entrypoint bash`, so the server is NOT running
# when the script starts: we launch it here, poll until it is ready, then drive a
# real sayHello round-trip and assert the installed gRPC version.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

SERVER_BIN="/usr/local/bin/greeter_server"
CLIENT_BIN="/usr/local/bin/greeter_client"
VERSION_FILE="/usr/local/share/grpc/version_info.h"
PORT="50051"

WORKDIR=""
SERVER_PID=""

cleanup() {
    if [ -n "${SERVER_PID}" ]; then
        if kill -0 "${SERVER_PID}" 2>/dev/null; then
            kill "${SERVER_PID}" 2>/dev/null
            local i=0
            while kill -0 "${SERVER_PID}" 2>/dev/null && [ "${i}" -lt 20 ]; do
                i=$((i + 1))
                sleep 0.5
            done
            kill -9 "${SERVER_PID}" 2>/dev/null
        fi
        wait "${SERVER_PID}" 2>/dev/null
    fi
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

detect_version() {
    local ver
    [ -f "${VERSION_FILE}" ] || return 1
    ver="$(sed -n 's/^#define GRPC_CPP_VERSION_STRING "\(.*\)"$/\1/p' "${VERSION_FILE}" | head -n 1)"
    [ -n "${ver}" ] || return 1
    printf '%s\n' "${ver}"
}

test_version() {
    local ver
    if [ ! -f "${VERSION_FILE}" ]; then
        echo "FAIL: gRPC C++ version header not found: ${VERSION_FILE}"
        return 1
    fi
    ver="$(detect_version)"
    if [ -z "${ver}" ]; then
        echo "FAIL: unable to determine the installed gRPC version"
        return 1
    fi
    if [ "${ver}" = "${EXPECTED_VERSION}" ]; then
        echo "PASS: installed gRPC version ${ver}"
        return 0
    fi
    echo "FAIL: expected grpc version ${EXPECTED_VERSION}, got ${ver}"
    return 1
}

wait_ready() {
    local log_file="$1" i=0
    while [ "${i}" -lt 30 ]; do
        if [ -f "${log_file}" ] && grep -q "Server listening on" "${log_file}" 2>/dev/null; then
            return 0
        fi
        if (exec 3<>"/dev/tcp/127.0.0.1/${PORT}") 2>/dev/null; then
            return 0
        fi
        if ! kill -0 "${SERVER_PID}" 2>/dev/null; then
            return 1
        fi
        i=$((i + 1))
        sleep 1
    done
    return 1
}

test_grpc_roundtrip() {
    local expected="Greeter received: Hello world"
    local log_file out_file out cpid i=0

    WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/grpc-test.XXXXXX")"
    log_file="${WORKDIR}/server.log"
    out_file="${WORKDIR}/client.out"

    if [ ! -x "${SERVER_BIN}" ]; then
        echo "FAIL: server binary not found or not executable: ${SERVER_BIN}"
        return 1
    fi
    if [ ! -x "${CLIENT_BIN}" ]; then
        echo "FAIL: client binary not found or not executable: ${CLIENT_BIN}"
        return 1
    fi

    nohup "${SERVER_BIN}" --port="${PORT}" >"${log_file}" 2>&1 &
    SERVER_PID=$!

    if ! wait_ready "${log_file}"; then
        echo "FAIL: gRPC hello-world server did not become ready on port ${PORT}"
        return 1
    fi

    "${CLIENT_BIN}" --target="localhost:${PORT}" >"${out_file}" 2>&1 &
    cpid=$!
    while kill -0 "${cpid}" 2>/dev/null; do
        i=$((i + 1))
        if [ "${i}" -gt 20 ]; then
            kill "${cpid}" 2>/dev/null
            break
        fi
        sleep 1
    done
    wait "${cpid}" 2>/dev/null
    out="$(cat "${out_file}" 2>/dev/null)"

    if grep -q "${expected}" "${out_file}" 2>/dev/null; then
        echo "PASS: gRPC sayHello round-trip returned '${expected}'"
        return 0
    fi

    echo "FAIL: expected '${expected}', got: $(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-300)"
    return 1
}

main() {
    local failures=0
    test_version || failures=$((failures + 1))
    test_grpc_roundtrip || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        return 0
    fi
    echo "TESTS_FAILED: ${failures} failure(s)"
    return 1
}

main "$@"
