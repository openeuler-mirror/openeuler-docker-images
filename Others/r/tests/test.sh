#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"
BINARY="Rscript"

test_version() {
    local out rc

    if ! command -v "${BINARY}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found: %s\n' "${BINARY}" >&2
        return 1
    fi

    if out="$("${BINARY}" -e 'cat(as.character(getRversion()))' 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: version command exited %s: %s\n' "${rc}" "${out}" >&2
        return 1
    fi

    if [[ "${out}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${out}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${out}"
}

test_core_function() {
    local out rc

    if out="$("${BINARY}" -e 'cat(mean(c(2, 4, 6, 8, 10)))' 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: core command exited %s: %s\n' "${rc}" "${out}" >&2
        return 1
    fi

    if [[ "${out}" != "6" ]]; then
        printf 'FAIL: core result mismatch: expected=<6> actual=<%s>\n' "${out}" >&2
        return 1
    fi

    printf 'PASS: core function (arithmetic mean)\n'
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
