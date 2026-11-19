#!/bin/bash
# KunpengTest functional test for oozie (version only).
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version dir name), DOCKER_NAMESPACE, DOCKER_PACKAGE,
# DOCKER_TAG, DOCKER_IMAGE.
#
# The only case asserts that oozie reports exactly ${EXPECTED_VERSION}.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

APP_NAME="oozie"

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
    return 1
}

app_version_output() {
    local j b
    for j in $(find /opt /usr/local -maxdepth 5 -name 'oozie-client-*.jar' 2>/dev/null | head -n 3); do
        printf '%s
' "${j}"
    done
    b="$(find_bin "oozie")" && "$b" "version" 2>&1 || true
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
    if [[ "${token}" =~ ^([0-9]+(\.[0-9A-Za-z]+)+) ]] && [ "${BASH_REMATCH[1]}" = "${EXPECTED_VERSION}" ]; then
        return 0
    fi
    return 1
}

test_version() {
    local out token
    out="$(app_version_output 2>&1 || true)"
    if [ -z "${out}" ]; then
        printf 'FAIL: %s produced no version output\n' "${APP_NAME}"
        return 1
    fi
    for token in $(printf '%s\n' "${out}" | tr -c 'A-Za-z0-9._+-' ' '); do
        if version_matches "${token}"; then
            printf 'PASS: %s reports version %s\n' "${APP_NAME}" "${EXPECTED_VERSION}"
            return 0
        fi
    done
    printf 'FAIL: expected %s version %s, got: %s\n' "${APP_NAME}" "${EXPECTED_VERSION}" \
        "$(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-300)"
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
