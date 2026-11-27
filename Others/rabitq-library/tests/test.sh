#!/bin/bash
# KunpengTest functional test for rabitq-library (header-only C++ library).
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version directory name), DOCKER_NAMESPACE,
# DOCKER_PACKAGE, DOCKER_TAG, DOCKER_IMAGE.
#
# The image ships only the RaBitQ-Library C++ headers (no binary/service):
#   WORKDIR /workspace; git clone .../RaBitQ-Library.git; git checkout v<VERSION>
#   cp -r include /usr/local/include/rabitq
# So the version is asserted from the git checkout, and the functional case
# asserts the installed headers are present and contain real library code.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

REPO_DIR="/workspace/RaBitQ-Library"
INC_DIR="/usr/local/include/rabitq"

test_version() {
    local tag sha
    if [ ! -d "${REPO_DIR}/.git" ]; then
        printf 'FAIL: RaBitQ git checkout not found at %s\n' "${REPO_DIR}"
        return 1
    fi
    tag="$(git -C "${REPO_DIR}" describe --tags --exact-match 2>/dev/null || true)"
    tag="${tag#v}"
    tag="${tag#V}"
    sha="$(git -C "${REPO_DIR}" rev-parse --short=7 HEAD 2>/dev/null || true)"
    if [ -n "${tag}" ] && [ "${tag}" = "${EXPECTED_VERSION}" ]; then
        printf 'PASS: RaBitQ version %s (git tag)\n' "${tag}"
        return 0
    fi
    if [ -n "${sha}" ] && [ "${sha}" = "${EXPECTED_VERSION}" ]; then
        printf 'PASS: RaBitQ version %s (git commit)\n' "${sha}"
        return 0
    fi
    printf 'FAIL: expected version %s, got tag=<%s> commit=<%s>\n' \
        "${EXPECTED_VERSION}" "${tag}" "${sha}"
    return 1
}

test_headers_installed() {
    local header="${INC_DIR}/rabitqlib/fastscan/fastscan.hpp"
    if [ ! -d "${INC_DIR}/rabitqlib" ]; then
        printf 'FAIL: RaBitQ include directory missing: %s\n' "${INC_DIR}/rabitqlib"
        return 1
    fi
    if [ ! -f "${header}" ]; then
        printf 'FAIL: header not found: %s\n' "${header}"
        return 1
    fi
    if ! grep -q 'namespace rabitqlib' "${header}"; then
        printf 'FAIL: header lacks rabitqlib namespace: %s\n' "${header}"
        return 1
    fi
    printf 'PASS: RaBitQ headers installed (%s)\n' "${header}"
    return 0
}

main() {
    local failures=0
    test_version          || failures=$((failures + 1))
    test_headers_installed || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"
