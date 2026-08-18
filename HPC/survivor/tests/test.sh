#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"
BINARY="SURVIVOR"

TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/survivor-test.XXXXXX")"
trap 'rm -rf "${TEST_DIR}"' EXIT

test_version() {
    local output line reported=""

    if ! command -v "${BINARY}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found in PATH: %s\n' "${BINARY}" >&2
        return 1
    fi

    if ! output="$("${BINARY}" 2>&1)"; then
        printf 'FAIL: "%s" (no args) exited with status %s\n' "${BINARY}" "$?" >&2
        return 1
    fi

    while IFS= read -r line; do
        case "${line}" in
            Version:*)
                reported="${line#Version: }"
                ;;
        esac
    done <<< "${output}"

    if [[ -z "${reported}" ]]; then
        printf 'FAIL: no "Version:" line found in output:\n%s\n' "${output}" >&2
        return 1
    fi

    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${reported}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${reported}"
}

test_core_function() {
    local input_vcf="${TEST_DIR}/input.vcf"
    local output_bed="${TEST_DIR}/output.bed"
    local expected_line="chr1	100	100	chr1	200	200	DEL1	,	+	-	DEL"
    local rc

    cat > "${input_vcf}" <<'EOF'
##fileformat=VCFv4.1
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO
chr1	100	DEL1	N	<DEL>	.	LowQual	IMPRECISE;END=200;SVTYPE=DEL
EOF

    if ! "${BINARY}" vcftobed "${input_vcf}" 0 -1 "${output_bed}" >/dev/null 2>&1; then
        rc=$?
        printf 'FAIL: SURVIVOR vcftobed exited with status %s\n' "${rc}" >&2
        return 1
    fi

    if [[ ! -f "${output_bed}" || ! -s "${output_bed}" ]]; then
        printf 'FAIL: vcftobed did not produce a non-empty output file: %s\n' \
            "${output_bed}" >&2
        return 1
    fi

    if ! grep -Fxq "${expected_line}" "${output_bed}"; then
        printf 'FAIL: vcftobed output missing expected BED line\n' >&2
        printf '  expected: <%s>\n' "${expected_line}" >&2
        printf '  actual output:\n' >&2
        cat "${output_bed}" >&2
        return 1
    fi

    printf 'PASS: vcftobed converted DEL record to expected BED line\n'
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
