#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

test_r_binary() {
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

    if output="$(Rscript -e 'cat(as.character(packageVersion("genomation")))' 2>&1)"; then
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

    printf 'PASS: exact genomation package version: %s\n' "${output}"
}

test_core_function() {
    local output rc

    if ! output="$(Rscript - 2>&1 <<'EOF'
suppressMessages(suppressWarnings({
    library(GenomicRanges)
    library(genomation)
}))

bed <- tempfile(fileext = ".bed")
writeLines(
    c("chr1\t100\t200",
      "chr2\t300\t400",
      "chr3\t500\t600"),
    bed
)

x <- readGeneric(bed)

if (!inherits(x, "GRanges")) {
    stop("readGeneric did not return a GRanges object")
}
if (length(x) != 3L) {
    stop(sprintf("expected 3 genomic intervals, got %d", length(x)))
}
expected_chr <- c("chr1", "chr2", "chr3")
obs_chr <- as.character(seqnames(x))
if (!identical(obs_chr, expected_chr)) {
    stop(sprintf("seqnames mismatch: expected <%s> got <%s>",
                 paste(expected_chr, collapse = ","),
                 paste(obs_chr, collapse = ",")))
}
expected_start <- c(100L, 300L, 500L)
obs_start <- as.integer(start(x))
if (!identical(obs_start, expected_start)) {
    stop(sprintf("start mismatch: expected <%s> got <%s>",
                 paste(expected_start, collapse = ","),
                 paste(obs_start, collapse = ",")))
}
expected_end <- c(200L, 400L, 600L)
obs_end <- as.integer(end(x))
if (!identical(obs_end, expected_end)) {
    stop(sprintf("end mismatch: expected <%s> got <%s>",
                 paste(expected_end, collapse = ","),
                 paste(obs_end, collapse = ",")))
}

cat("CORE_OK: readGeneric parsed 3 BED records into a GRanges with expected coordinates\n")
EOF
)"; then
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

    if ! test_r_binary; then
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