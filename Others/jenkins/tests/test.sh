#!/bin/bash

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

JAVA_BIN="java"
JENKINS_WAR="/jenkins/jenkins.war"
JENKINS_PORT="8080"
JENKINS_HOME_DIR=""
SERVER_PID=""

cleanup() {
    if [ -n "${SERVER_PID}" ] && kill -0 "${SERVER_PID}" 2>/dev/null; then
        kill "${SERVER_PID}" 2>/dev/null
        wait "${SERVER_PID}" 2>/dev/null
    fi
    if [ -n "${JENKINS_HOME_DIR}" ] && [ -d "${JENKINS_HOME_DIR}" ]; then
        rm -rf "${JENKINS_HOME_DIR}" 2>/dev/null
    fi
}
trap cleanup EXIT

http_get_status() {
    local host="$1" port="$2" line

    if exec 3<>"/dev/tcp/${host}/${port}" 2>/dev/null; then
        printf 'GET / HTTP/1.1\r\nHost: %s\r\nConnection: close\r\n\r\n' "${host}" >&3
        IFS= read -r -t 10 line <&3
        exec 3>&- 3<&-
        line="$(printf '%s' "${line}" | sed -n 's/^HTTP\/[0-9.]* \([0-9]*\).*/\1/p')"
        printf '%s' "${line}"
        return 0
    fi

    if command -v curl >/dev/null 2>&1; then
        line="$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 "http://${host}:${port}/" 2>/dev/null)"
        printf '%s' "${line}"
        return 0
    fi

    return 1
}

test_version() {
    local out

    if ! command -v "${JAVA_BIN}" >/dev/null 2>&1; then
        printf 'FATAL: java binary not found in PATH\n' >&2
        return 1
    fi
    if [ ! -f "${JENKINS_WAR}" ]; then
        printf 'FATAL: jenkins.war not found: %s\n' "${JENKINS_WAR}" >&2
        return 1
    fi

    out="$("${JAVA_BIN}" -jar "${JENKINS_WAR}" --version 2>&1 || true)"
    out="$(printf '%s' "${out}" | tr -d '\r\n')"

    if [ -n "${out}" ] && [ "${out}" = "${EXPECTED_VERSION}" ]; then
        printf 'PASS: exact jenkins version: %s\n' "${out}"
        return 0
    fi

    printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' "${EXPECTED_VERSION}" "${out}"
    return 1
}

test_service() {
    local pwd_file passwd tries status

    status="$(http_get_status 127.0.0.1 "${JENKINS_PORT}" 2>/dev/null || true)"
    if [ -n "${status}" ] && [ "${status}" != "503" ]; then
        printf 'PASS: jenkins service already serving HTTP %s on port %s\n' \
            "${status}" "${JENKINS_PORT}"
        return 0
    fi

    JENKINS_HOME_DIR="$(mktemp -d "${TMPDIR:-/tmp}/jenkins-home.XXXXXX")" || {
        printf 'FAIL: cannot create temporary jenkins home\n' >&2
        return 1
    }
    pwd_file="${JENKINS_HOME_DIR}/secrets/initialAdminPassword"

    JENKINS_HOME="${JENKINS_HOME_DIR}" "${JAVA_BIN}" -jar "${JENKINS_WAR}" \
        --httpPort="${JENKINS_PORT}" >"${JENKINS_HOME_DIR}/server.log" 2>&1 &
    SERVER_PID=$!

    tries=0
    while [ "${tries}" -lt 120 ]; do
        if ! kill -0 "${SERVER_PID}" 2>/dev/null; then
            printf 'FAIL: jenkins server exited prematurely\n' >&2
            return 1
        fi
        if [ -s "${pwd_file}" ]; then
            break
        fi
        tries=$((tries + 1))
        sleep 1
    done

    if [ ! -s "${pwd_file}" ]; then
        printf 'FAIL: initial admin password not generated within timeout\n' >&2
        return 1
    fi

    passwd="$(cat "${pwd_file}" 2>/dev/null)"
    if ! printf '%s' "${passwd}" | grep -Eq '^[0-9a-f]{32}$'; then
        printf 'FAIL: unexpected initial admin password format\n' >&2
        return 1
    fi

    tries=0
    status=""
    while [ "${tries}" -lt 30 ]; do
        status="$(http_get_status 127.0.0.1 "${JENKINS_PORT}" 2>/dev/null || true)"
        if [ -n "${status}" ] && [ "${status}" != "503" ]; then
            break
        fi
        tries=$((tries + 1))
        sleep 1
    done

    if [ -n "${status}" ] && [ "${status}" != "503" ]; then
        printf 'PASS: jenkins service initialized and serving HTTP %s on port %s\n' \
            "${status}" "${JENKINS_PORT}"
        return 0
    fi

    printf 'FAIL: jenkins HTTP endpoint not ready (status=<%s>)\n' "${status}"
    return 1
}

main() {
    local failures=0

    test_version || failures=$((failures + 1))
    test_service || failures=$((failures + 1))

    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi

    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
    return 1
}

main "$@"
