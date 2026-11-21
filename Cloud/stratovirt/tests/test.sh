#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

BINARY="stratovirt"

test_version() {
    local output name ver rest

    if ! command -v "${BINARY}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found: %s\n' "${BINARY}" >&2
        return 1
    fi

    if ! output="$("${BINARY}" -version 2>&1)"; then
        printf 'FAIL: -version exited nonzero: %s\n' "${output}" >&2
        return 1
    fi

    read -r name ver rest <<< "${output}"

    if [[ "${name}" != "StratoVirt" ]]; then
        printf 'FAIL: unexpected version banner: %s\n' "${output}" >&2
        return 1
    fi

    if [[ "${ver}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${ver}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${ver}"
}

test_help() {
    local output opt

    if ! output="$("${BINARY}" -help 2>&1)"; then
        printf 'FAIL: -help exited nonzero: %s\n' "${output}" >&2
        return 1
    fi

    for opt in USAGE: FLAGS: -help -version -machine -kernel -drive -device -qmp; do
        if [[ "${output}" != *"${opt}"* ]]; then
            printf 'FAIL: --help missing expected option <%s>\n' "${opt}" >&2
            return 1
        fi
    done

    printf 'PASS: help lists usage and expected options\n'
}

test_config_validation() {
    local output

    if output="$("${BINARY}" -machine microvm 2>&1)"; then
        printf 'FAIL: -machine microvm without -kernel unexpectedly succeeded\n' >&2
        return 1
    fi

    if [[ "${output}" != *"kernel file is required for microvm machine type"* ]]; then
        printf 'FAIL: expected microvm kernel validation error, got: %s\n' \
            "${output:0:300}" >&2
        return 1
    fi

    printf 'PASS: config validation rejects microvm without kernel\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_help; then
        failures=$((failures + 1))
    fi
    if ! test_config_validation; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"