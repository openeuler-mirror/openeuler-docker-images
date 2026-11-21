#!/bin/bash
# KunpengTest functional test for grpc-server (gRPC Java hello-world example).
#
# The image builds the grpc-java examples with `./gradlew installDist` and its
# entrypoint runs `hello-world-server`, which listens on port 50051. CI executes
# this script with `--entrypoint bash`, so the server is NOT running when the
# script starts: we launch it here, poll until it is ready, then drive a real
# sayHello round-trip using the bundled `hello-world-client` and assert the
# installed gRPC version from the jars produced by `installDist`.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

APP_ROOT="/home/grpc-java/examples"
DIST="${APP_ROOT}/build/install/examples"
BIN_DIR="${DIST}/bin"
LIB_DIR="${DIST}/lib"
SERVER_BIN="${BIN_DIR}/hello-world-server"
CLIENT_BIN="${BIN_DIR}/hello-world-client"
PORT="50051"
GREET_NAME="kunpengtest"

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
    local artifact jar base ver
    for artifact in grpc-core grpc-api grpc-stub grpc-protobuf grpc-netty-shaded grpc-services; do
        for jar in "${LIB_DIR}/${artifact}-"*.jar; do
            [ -e "${jar}" ] || continue
            base="${jar##*/}"
            ver="${base#"${artifact}-"}"
            ver="${ver%.jar}"
            printf '%s\n' "${ver}"
            return 0
        done
    done
    return 1
}

test_version() {
    local ver
    if [ ! -d "${LIB_DIR}" ]; then
        echo "FAIL: installDist library directory not found: ${LIB_DIR}"
        return 1
    fi
    ver="$(detect_version)"
    if [ -z "${ver}" ]; then
        echo "FAIL: no grpc-*.jar found in ${LIB_DIR}"
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
        if [ -f "${log_file}" ] && grep -q "Server started, listening on ${PORT}" "${log_file}" 2>/dev/null; then
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
    local log_file out_file out cpid i=0
    WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/grpc-server-test.XXXXXX")"
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

    nohup "${SERVER_BIN}" >"${log_file}" 2>&1 &
    SERVER_PID=$!

    if ! wait_ready "${log_file}"; then
        echo "FAIL: gRPC hello-world server did not become ready on port ${PORT}"
        return 1
    fi

    "${CLIENT_BIN}" "${GREET_NAME}" "localhost:${PORT}" >"${out_file}" 2>&1 &
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

    if printf '%s' "${out}" | grep -q "Greeting: Hello ${GREET_NAME}"; then
        echo "PASS: gRPC sayHello round-trip returned 'Hello ${GREET_NAME}'"
        return 0
    fi

    echo "FAIL: expected greeting 'Hello ${GREET_NAME}', got: $(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-300)"
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
