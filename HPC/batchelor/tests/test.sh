#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

test_binary() {
    if ! command -v R >/dev/null 2>&1; then
        printf 'FAIL: R binary not found on PATH\n' >&2
        return 1
    fi
    if ! command -v Rscript >/dev/null 2>&1; then
        printf 'FAIL: Rscript binary not found on PATH\n' >&2
        return 1
    fi
    printf 'PASS: R and Rscript available\n'
}

test_version() {
    local output rc

    if output="$(Rscript -e 'cat(as.character(packageVersion("batchelor")))' 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: version query exited %s: %s\n' \
            "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact batchelor package version: %s\n' "${output}"
}

test_core_function() {
    local output rc

    if output="$(Rscript - 2>&1 <<'EOF'
suppressMessages(suppressWarnings(library(batchelor)))
set.seed(100)
B1 <- matrix(rnorm(10000, -1), ncol = 50) # batch 1: 200 genes x 50 cells
B2 <- matrix(rnorm(10000, 1), ncol = 50)  # batch 2: 200 genes x 50 cells
out <- fastMNN(A = B1, B = B2, d = 10)
corrected <- reducedDim(out, "corrected")
if (nrow(corrected) != 100) {
    stop(sprintf("expected corrected matrix with 100 rows (cells), got %d", nrow(corrected)))
}
if (ncol(corrected) != 10) {
    stop(sprintf("expected corrected matrix with 10 columns (d), got %d", ncol(corrected)))
}
if (!all(is.finite(corrected))) {
    stop("corrected matrix contains non-finite values")
}
batch <- as.character(out$batch)
if (length(batch) != 100) {
    stop(sprintf("expected batch labels for 100 cells, got %d", length(batch)))
}
if (!identical(sort(unique(batch)), c("A", "B"))) {
    stop(sprintf("expected batch levels A and B, got: %s", paste(unique(batch), collapse = ",")))
}
if (sum(batch == "A") != 50 || sum(batch == "B") != 50) {
    stop("expected 50 cells from each batch")
}
cat("CORE_OK: fastMNN returned corrected embedding",
    paste(dim(corrected), collapse = "x"),
    "with 50 cells from each of batches A and B\n")
EOF
)"; then
        :
    else
        rc=$?
        printf 'FAIL: core function exited %s:\n%s\n' \
            "${rc}" "${output}" >&2
        return 1
    fi

    if ! grep -q 'CORE_OK' <<<"${output}"; then
        printf 'FAIL: core function did not complete successfully:\n%s\n' \
            "${output}" >&2
        return 1
    fi

    printf '%s\n' "${output}"
}

main() {
    local failures=0

    if ! test_binary; then
        failures=$((failures + 1))
    fi
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