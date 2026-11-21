#!/bin/bash
# KunpengTest functional test for rabbitmq.
#
# CI executes this file inside the image under test with `--entrypoint bash`
# and the script directory mounted read-only at /tmp/eptest. The broker does
# NOT auto-start (the default entrypoint is overridden), so the service test
# starts rabbitmq-server itself, waits for it to be fully booted, then drives
# a real write-read path through the broker before tearing it down.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

RABBITMQCTL="rabbitmqctl"
RABBITMQ_DIAGNOSTICS="rabbitmq-diagnostics"
SERVER_PID=""
WORKDIR=""

cleanup() {
    if [ -n "${SERVER_PID}" ]; then
        "${RABBITMQCTL}" stop >/dev/null 2>&1
        kill "${SERVER_PID}" 2>/dev/null
        wait "${SERVER_PID}" 2>/dev/null
    fi
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_version() {
    local out
    if ! command -v "${RABBITMQCTL}" >/dev/null 2>&1; then
        printf 'FAIL: rabbitmqctl not found on PATH\n'
        return 1
    fi
    out="$( "${RABBITMQCTL}" version 2>/dev/null || true )"
    out="$( printf '%s' "${out}" | tr -d '[:space:]' )"
    if [ "${out}" = "${EXPECTED_VERSION}" ]; then
        printf 'PASS: rabbitmqctl reports version %s\n' "${EXPECTED_VERSION}"
        return 0
    fi
    printf 'FAIL: expected rabbitmq version %s, got %s\n' "${EXPECTED_VERSION}" "${out}"
    return 1
}

test_service() {
    local i out

    if ! command -v "${RABBITMQ_DIAGNOSTICS}" >/dev/null 2>&1; then
        printf 'FAIL: rabbitmq-diagnostics not found on PATH\n'
        return 1
    fi

    WORKDIR="$( mktemp -d )" || {
        printf 'FAIL: could not create temporary directory\n'
        return 1
    }

    rabbitmq-server >"${WORKDIR}/rabbitmq.log" 2>&1 &
    SERVER_PID=$!

    for (( i = 0; i < 40; i++ )); do
        if "${RABBITMQ_DIAGNOSTICS}" -t 5 check_running >/dev/null 2>&1; then
            break
        fi
        sleep 1
    done
    if [ "${i}" -ge 40 ]; then
        printf 'FAIL: rabbitmq broker did not become ready within 40s\n'
        return 1
    fi

    if ! "${RABBITMQCTL}" add_vhost kunpengtest >/dev/null 2>&1; then
        printf 'FAIL: rabbitmqctl add_vhost kunpengtest failed\n'
        return 1
    fi

    out="$( "${RABBITMQCTL}" list_vhosts name 2>/dev/null || true )"
    if ! printf '%s\n' "${out}" | grep -qF 'kunpengtest'; then
        printf 'FAIL: created vhost kunpengtest not found in list_vhosts output\n'
        "${RABBITMQCTL}" delete_vhost kunpengtest >/dev/null 2>&1 || true
        return 1
    fi

    "${RABBITMQCTL}" delete_vhost kunpengtest >/dev/null 2>&1 || true

    printf 'PASS: rabbitmq add_vhost/list_vhosts write-read round trip\n'
    return 0
}

main() {
    local failures=0
    test_version || failures=$(( failures + 1 ))
    test_service || failures=$(( failures + 1 ))
    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"
