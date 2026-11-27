#!/bin/bash
# KunpengTest functional test for orientdb.
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version dir name), DOCKER_NAMESPACE, DOCKER_PACKAGE,
# DOCKER_TAG, DOCKER_IMAGE.
#
# OrientDB is a server. The default entrypoint (server.sh) is overridden by
# --entrypoint bash, so this script starts the server itself, waits for it to
# listen on the HTTP port (2480), then drives a real write/read data path
# through the console (create database, insert, select). Version is asserted
# from the console startup banner.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

APP_NAME="orientdb"
SERVER_BIN="/orientdb/bin/server.sh"
CONSOLE_BIN="/orientdb/bin/console.sh"
HTTP_PORT="2480"
ROOT_PASSWORD="OrientDB_EPTest_123!"

WORKDIR=""
SERVER_PID=""

cleanup() {
    if [ -n "${SERVER_PID}" ]; then
        kill "${SERVER_PID}" 2>/dev/null
        wait "${SERVER_PID}" 2>/dev/null
    fi
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

wait_server_ready() {
    local attempts=0
    while [ "${attempts}" -lt 45 ]; do
        if (exec 3<>"/dev/tcp/127.0.0.1/${HTTP_PORT}") 2>/dev/null; then
            return 0
        fi
        attempts=$((attempts + 1))
        sleep 1
    done
    return 1
}

test_version() {
    local out version
    if [ ! -x "${CONSOLE_BIN}" ]; then
        echo "FATAL: ${CONSOLE_BIN} not found or not executable"
        return 1
    fi
    out="$("${CONSOLE_BIN}" "exit" 2>&1 || true)"
    version="$(printf '%s\n' "${out}" \
        | grep -oE 'OrientDB console v\.[0-9]+\.[0-9]+\.[0-9]+' \
        | head -n 1 \
        | sed 's/OrientDB console v\.//')"
    if [ -n "${version}" ] && [ "${version}" = "${EXPECTED_VERSION}" ]; then
        echo "PASS: ${APP_NAME} console reports exact version ${EXPECTED_VERSION}"
        return 0
    fi
    echo "FAIL: expected ${APP_NAME} console version ${EXPECTED_VERSION}, got '${version}'"
    return 1
}

test_server_data() {
    local out
    if [ ! -x "${SERVER_BIN}" ] || [ ! -x "${CONSOLE_BIN}" ]; then
        echo "FATAL: orientdb bin scripts not found under /orientdb/bin"
        return 1
    fi

    WORKDIR="$(mktemp -d)"

    ORIENTDB_ROOT_PASSWORD="${ROOT_PASSWORD}" \
        ORIENTDB_OPTS_MEMORY="-Xms256m -Xmx1024m" \
        "${SERVER_BIN}" > "${WORKDIR}/server.log" 2>&1 &
    SERVER_PID=$!

    if ! wait_server_ready; then
        echo "FAIL: ${APP_NAME} server did not listen on port ${HTTP_PORT} within timeout"
        return 1
    fi

    cat > "${WORKDIR}/cmds.osql" <<EOF
connect remote:localhost root ${ROOT_PASSWORD}
create database remote:localhost/eptestdb root ${ROOT_PASSWORD} plocal
create class Eptest
insert into Eptest set name = 'eptest_marker', value = 42
select from Eptest
EOF

    out="$("${CONSOLE_BIN}" "${WORKDIR}/cmds.osql" 2>&1 || true)"

    if printf '%s\n' "${out}" | grep -q "Database created successfully" \
        && printf '%s\n' "${out}" | grep -q "Inserted record" \
        && printf '%s\n' "${out}" | grep -q "eptest_marker"; then
        echo "PASS: ${APP_NAME} server create/insert/select write-read path works"
        return 0
    fi

    printf 'FAIL: %s write-read path failed: %s\n' "${APP_NAME}" \
        "$(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-400)"
    return 1
}

main() {
    local failures=0
    test_version     || failures=$((failures + 1))
    test_server_data || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        return 0
    fi
    echo "TESTS_FAILED: ${failures} failure(s)"
    return 1
}

main "$@"
