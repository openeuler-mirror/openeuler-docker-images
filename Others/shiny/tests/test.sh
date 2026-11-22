#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

RSCRIPT="Rscript"
R_BIN="R"

test_runtime_present() {
    if ! command -v "${RSCRIPT}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found: %s\n' "${RSCRIPT}" >&2
        return 1
    fi
    if ! command -v "${R_BIN}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found: %s\n' "${R_BIN}" >&2
        return 1
    fi
    printf 'PASS: R runtime present (R and Rscript)\n'
}

test_shiny_version() {
    local output rc

    if ! output="$("${RSCRIPT}" -e 'cat(as.character(packageVersion("shiny")))' 2>&1)"; then
        rc=$?
        printf 'FAIL: packageVersion("shiny") exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: shiny version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact shiny version: %s\n' "${output}"
}

test_shiny_reactive_engine() {
    local output rc

    if ! output="$("${RSCRIPT}" -e \
        'v <- shiny::reactiveVal(1); r <- shiny::reactive({ v() * 21 }); v(2); stopifnot(shiny::isolate(r()) == 42); cat("reactive-ok")' \
        2>&1)"; then
        rc=$?
        printf 'FAIL: shiny reactive-engine check exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "reactive-ok" ]]; then
        printf 'FAIL: reactive result mismatch: expected=<reactive-ok> actual=<%s>\n' \
            "${output}" >&2
        return 1
    fi

    printf 'PASS: shiny reactive dependency engine (write-then-read)\n'
}

main() {
    local failures=0

    if ! test_runtime_present; then
        failures=$((failures + 1))
    fi
    if ! test_shiny_version; then
        failures=$((failures + 1))
    fi
    if ! test_shiny_reactive_engine; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"