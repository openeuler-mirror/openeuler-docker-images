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

    if output="$(Rscript -e 'cat(as.character(packageVersion("hdWGCNA")))' 2>&1)"; then
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

    printf 'PASS: exact hdWGCNA package version: %s\n' "${output}"
}

test_core_function() {
    local output rc

    if ! output="$(Rscript - 2>&1 <<'EOF'
suppressMessages(suppressWarnings(library(hdWGCNA)))
data(test_seurat)
genes <- rownames(test_seurat)[1:200]
seurat_obj <- suppressWarnings(SetupForWGCNA(
    test_seurat,
    wgcna_name = 'test',
    features = genes
))
wgcna_genes <- GetWGCNAGenes(seurat_obj, 'test')
if (length(wgcna_genes) != length(genes)) {
    stop(sprintf('expected %d WGCNA genes, got %d', length(genes), length(wgcna_genes)))
}
if (!identical(wgcna_genes, genes)) {
    stop('SetupForWGCNA/GetWGCNAGenes round-trip failed: stored genes differ from custom input genes')
}
cat('CORE_OK: SetupForWGCNA stored and GetWGCNAGenes returned all ', length(wgcna_genes), ' custom genes\n', sep = '')
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
