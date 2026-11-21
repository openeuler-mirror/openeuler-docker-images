#!/bin/bash
# KunpengTest functional test for drbd (kernel module, version only).
#
# CI executes this file inside the image under test with --entrypoint bash and
# the test directory mounted read-only at /opt/oe-tests. Injected env vars:
# EXPECTED_VERSION (image version dir name).
#
# The image builds the DRBD 9 kernel module (drbd.ko) from LINBIT/drbd
# (tag drbd-${EXPECTED_VERSION}). The only case asserts that the installed
# module reports exactly ${EXPECTED_VERSION}.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

APP_NAME="drbd"

find_module() {
    local m
    for m in /lib/modules/*/updates/drbd.ko \
             /lib/modules/*/extra/drbd.ko \
             /lib/modules/*/drbd/drbd.ko; do
        if [ -f "${m}" ]; then
            printf '%s\n' "${m}"
            return 0
        fi
    done
    return 1
}

module_version() {
    local m version
    m="$(find_module)" || return 1
    version="$(modinfo "${m}" 2>/dev/null | grep '^version:' | head -n 1 \
        | sed 's/^version:[[:space:]]*//' | tr -d '[:space:]')"
    [ -n "${version}" ] || return 1
    printf '%s\n' "${version}"
}

version_matches() {
    local token="$1" part
    token="${token#v}"; token="${token#V}"
    [ "${token}" = "${EXPECTED_VERSION}" ] && return 0
    while IFS= read -r part; do
        [ -n "${part}" ] || continue
        part="${part#v}"; part="${part#V}"
        [ "${part}" = "${EXPECTED_VERSION}" ] && return 0
    done < <(printf '%s\n' "${token}" | tr '/-' '\n')
    return 1
}

test_version() {
    local version
    version="$(module_version 2>/dev/null)" || true
    if [ -z "${version}" ]; then
        printf 'FAIL: drbd kernel module (drbd.ko) not found under /lib/modules or reports no version\n'
        return 1
    fi
    if version_matches "${version}"; then
        printf 'PASS: %s reports version %s\n' "${APP_NAME}" "${EXPECTED_VERSION}"
        return 0
    fi
    printf 'FAIL: expected %s version %s, got: %s\n' "${APP_NAME}" "${EXPECTED_VERSION}" "${version}"
    return 1
}

main() {
    local failures=0
    test_version || failures=$((failures + 1))

    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"
