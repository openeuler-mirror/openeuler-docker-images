#!/bin/bash
# KunpengTest functional test for tidb (version only).
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version dir name), DOCKER_NAMESPACE, DOCKER_PACKAGE,
# DOCKER_TAG, DOCKER_IMAGE.
#
# The only case asserts that tidb reports exactly ${EXPECTED_VERSION}.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

APP_NAME="tidb"

find_bin() {
    local name="$1" p
    command -v "${name}" 2>/dev/null && return 0
    for p in /usr/local/bin/"${name}" /usr/bin/"${name}" /bin/"${name}" \
             /usr/local/sbin/"${name}" /usr/sbin/"${name}" /sbin/"${name}" \
             /opt/*/bin/"${name}" /opt/*/*/bin/"${name}" \
             /usr/local/*/bin/"${name}" /usr/*/bin/"${name}"; do
        if [ -x "${p}" ]; then
            printf '%s\n' "${p}"
            return 0
        fi
    done
    p="$(find / -maxdepth 6 -type f -name "${name}" -perm -u+x 2>/dev/null | head -n 1)"
    if [ -n "${p}" ]; then
        printf '%s\n' "${p}"
        return 0
    fi
    return 1
}

app_version_output() {
    local b
    b="$(find_bin "tidb-server")" || b="/tidb-server"
    [ -x "${b}" ] || return 0
    "${b}" "-V" 2>&1
}

version_matches() {
    local token="$1"
    token="${token#v}"; token="${token#V}"
    [ "${token}" = "${EXPECTED_VERSION}" ]
}

test_version() {
    local out token msg
    out="$(app_version_output 2>&1 || true)"
    if [ -z "${out}" ]; then
        printf 'FAIL: %s produced no version output\n' "${APP_NAME}"
        return 1
    fi
    for token in ${out//[^A-Za-z0-9._+-]/ }; do
        if version_matches "${token}"; then
            printf 'PASS: %s reports version %s\n' "${APP_NAME}" "${EXPECTED_VERSION}"
            return 0
        fi
    done
    msg="${out//$'\n'/ }"
    printf 'FAIL: expected %s version %s, got: %s\n' "${APP_NAME}" "${EXPECTED_VERSION}" "${msg:0:300}"
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
