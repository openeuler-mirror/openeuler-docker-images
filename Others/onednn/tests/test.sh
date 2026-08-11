#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"
BINARY="onednn-getting-started"

test_binary_exists() {
    if ! command -v "${BINARY}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found in PATH: %s\n' "${BINARY}" >&2
        return 1
    fi
    printf 'PASS: binary present: %s\n' "${BINARY}"
}

test_exact_version() {
    local output rest reported rc

    if ! output="$(ONEDNN_VERBOSE=1 "${BINARY}" 2>&1)"; then
        rc=$?
        printf 'FAIL: %s exited %s while emitting verbose version\n' \
            "${BINARY}" "${rc}" >&2
        return 1
    fi

    rest="${output##*oneDNN v}"
    reported="${rest%% *}"

    if [[ ! "${reported}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        printf 'FAIL: oneDNN verbose version line not found in output\n' >&2
        return 1
    fi

    if [[ "${reported}" != "${EXPECTED_VERSION}.0" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}.0" "${reported}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${reported}"
}

test_core_function() {
    local output rc

    if ! output="$("${BINARY}" 2>&1)"; then
        rc=$?
        printf 'FAIL: %s exited %s: %s\n' "${BINARY}" "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != *"Example passed on CPU."* ]]; then
        printf 'FAIL: getting_started example did not pass on CPU: %s\n' \
            "${output}" >&2
        return 1
    fi

    printf 'PASS: getting_started example executed ReLU on CPU\n'
}

main() {
    local failures=0

    if ! test_binary_exists; then
        failures=$((failures + 1))
    fi
    if ! test_exact_version; then
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
