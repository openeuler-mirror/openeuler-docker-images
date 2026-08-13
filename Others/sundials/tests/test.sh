#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

INSTALL_PREFIX=/usr/local/sundials
CONFIG_HEADER=${INSTALL_PREFIX}/include/sundials/sundials_config.h
EXAMPLE_DIR=${INSTALL_PREFIX}/examples/cvode/serial
EXAMPLE_BIN=${EXAMPLE_DIR}/cvRoberts_dns

test_version() {
    if [[ ! -f "${CONFIG_HEADER}" ]]; then
        printf 'FAIL: version header not found: %s\n' "${CONFIG_HEADER}" >&2
        return 1
    fi

    if ! grep -Fq "#define SUNDIALS_VERSION \"${EXPECTED_VERSION}\"" "${CONFIG_HEADER}"; then
        printf 'FAIL: %s does not define SUNDIALS_VERSION "%s"\n' \
            "${CONFIG_HEADER}" "${EXPECTED_VERSION}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${EXPECTED_VERSION}"
}

test_core_function() {
    local output rc

    if [[ ! -x "${EXAMPLE_BIN}" ]]; then
        printf 'FAIL: example binary not found: %s\n' "${EXAMPLE_BIN}" >&2
        return 1
    fi

    if ! output=$(cd "${EXAMPLE_DIR}" && ./cvRoberts_dns 2>&1); then
        rc=$?
        printf 'FAIL: cvRoberts_dns exited %s\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if ! printf '%s\n' "${output}" | grep -Fq '3-species kinetics problem'; then
        printf 'FAIL: missing problem header in output\n' >&2
        return 1
    fi

    if ! printf '%s\n' "${output}" | grep -Fq 'At t = 4.0000e+10'; then
        printf 'FAIL: integration did not reach final output time t=4e10\n' >&2
        return 1
    fi

    if ! printf '%s\n' "${output}" | grep -Fq 'Final Statistics:'; then
        printf 'FAIL: missing final statistics block\n' >&2
        return 1
    fi

    printf 'PASS: core function (cvRoberts_dns stiff ODE solve reached t=4e10 and passed reference check)\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_core_function; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
