#!/bin/bash
# KunpengTest functional test for busco (version only).
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version dir name), DOCKER_NAMESPACE, DOCKER_PACKAGE,
# DOCKER_TAG, DOCKER_IMAGE.
#
# `busco --version` is unusable in this image: bin/busco constructs
# BuscoLogger during startup, and BuscoLogger.__init__ creates
# busco_<pid>.log in the current directory. When that directory is not
# writable (the CI mount is read-only) logging.FileHandler raises IOError and
# BuscoLogger turns it into BatchFatalError, so the version is never printed.
# Query the installed package metadata instead: importing busco only loads
# busco/_version.py and never initialises the logger or touches the FS.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

APP_NAME="busco"

app_version_output() {
    local out
    out="$(python3 -c 'import busco; print(busco.__version__)' 2>&1)" && {
        printf '%s\n' "${out}"
        return 0
    }
    out="$(python3 -c 'import importlib.metadata as m; print(m.version("busco"))' 2>&1)" && {
        printf '%s\n' "${out}"
        return 0
    }
    printf '%s\n' "${out}"
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
