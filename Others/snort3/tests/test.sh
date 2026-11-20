#!/bin/bash
# KunpengTest functional test for snort3.
#
# CI runs this file inside the image under test with --entrypoint bash and the
# script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version dir name), DOCKER_NAMESPACE, DOCKER_PACKAGE,
# DOCKER_TAG, DOCKER_IMAGE.
#
# Cases:
#   1. snort --dump-version reports exactly ${EXPECTED_VERSION}.
#   2. snort validates the shipped default config in test mode (-T).

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

SNORT_CONF="/usr/local/etc/snort/snort.lua"
WORKDIR=""

cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

find_snort() {
    if command -v snort >/dev/null 2>&1; then
        command -v snort
        return 0
    fi
    local p
    for p in /usr/local/bin/snort /usr/local/sbin/snort /usr/bin/snort /usr/sbin/snort; do
        if [ -x "${p}" ]; then
            printf '%s\n' "${p}"
            return 0
        fi
    done
    return 1
}

test_version() {
    local bin out version
    bin="$(find_snort)" || {
        printf 'FATAL: snort binary not found\n'
        return 1
    }
    out="$( "${bin}" --dump-version 2>&1 || true )"
    version="$(printf '%s' "${out}" | tr -d '[:space:]')"
    if [ -n "${version}" ] && [ "${version}" = "${EXPECTED_VERSION}" ]; then
        printf 'PASS: snort --dump-version reports %s\n' "${version}"
        return 0
    fi
    printf 'FAIL: expected version %s, got %s\n' "${EXPECTED_VERSION}" "${version:-<empty>}"
    return 1
}

test_config_validation() {
    local bin out rc
    bin="$(find_snort)" || {
        printf 'FATAL: snort binary not found\n'
        return 1
    }
    if [ ! -f "${SNORT_CONF}" ]; then
        printf 'FAIL: default config not found: %s\n' "${SNORT_CONF}"
        return 1
    fi
    WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/snort-test.XXXXXX")"
    out="$( "${bin}" -c "${SNORT_CONF}" -l "${WORKDIR}" -T 2>&1 )"
    rc=$?
    if [ "${rc}" -eq 0 ] && [[ "${out}" == *"successfully validated the configuration"* ]]; then
        printf 'PASS: snort validated default configuration\n'
        return 0
    fi
    printf 'FAIL: snort -T exited %s (expected successful validation); output: %s\n' \
        "${rc}" "$(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-300)"
    return 1
}

main() {
    local failures=0
    test_version          || failures=$((failures + 1))
    test_config_validation || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"
