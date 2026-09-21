#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# The `gatk` launcher (a Python script shipped in the release archive) runs
# java -jar $GATK_LOCAL_JAR and forwards the remaining arguments to
# org.broadinstitute.hellbender.Main. The toolkit banner printed by
# Main.printVersionInfo() is "<Implementation-Title> v<Implementation-Version>"
# and build.gradle pins Implementation-Title to the exact string below, so the
# reported version can be extracted from that one line and compared exactly.
BINARY="gatk"
TOOLKIT_TITLE="The Genome Analysis Toolkit (GATK)"

test_version() {
    local out_file err_file rc line reported

    if ! command -v "${BINARY}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found: %s\n' "${BINARY}" >&2
        return 1
    fi

    out_file="$(mktemp "${TMPDIR:-/tmp}/gatk-version-out.XXXXXX")"
    err_file="$(mktemp "${TMPDIR:-/tmp}/gatk-version-err.XXXXXX")"

    if "${BINARY}" --version >"${out_file}" 2>"${err_file}"; then
        :
    else
        rc=$?
        printf 'FAIL: %s --version exited %s\n' "${BINARY}" "${rc}" >&2
        printf -- '--- stdout ---\n%s\n' "$(cat "${out_file}")" >&2
        printf -- '--- stderr ---\n%s\n' "$(cat "${err_file}")" >&2
        rm -f "${out_file}" "${err_file}"
        return 1
    fi
    rm -f "${err_file}"

    if ! line="$(grep -m1 -F "${TOOLKIT_TITLE}" "${out_file}")"; then
        printf 'FAIL: version banner not found in %s --version output\n' "${BINARY}" >&2
        printf -- '--- stdout ---\n%s\n' "$(cat "${out_file}")" >&2
        rm -f "${out_file}"
        return 1
    fi
    rm -f "${out_file}"

    reported="${line##* }"
    reported="${reported#v}"

    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${reported}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${reported}"
}

# CountReads is a GATK read walker. It counts every read that passes the
# default WellformedReadFilter and writes that count, as a decimal string, to
# the file given with -O/--output. The count below must be 2 for the two
# well-formed reads written into the SAM (each read carries an RG tag matching
# the @RG header line, a CIGAR whose length matches the sequence/quality
# length, a valid alignment start, and a contig present in the @SQ dictionary).
test_count_reads() {
    local work rc output count_file actual

    work="$(mktemp -d "${TMPDIR:-/tmp}/gatk-countreads.XXXXXX")"
    printf '@HD\tVN:1.6\tSO:coordinate\n@SQ\tSN:chr1\tLN:1000\n@RG\tID:rg1\tSM:sample1\tPL:ILLUMINA\nr1\t0\tchr1\t100\t60\t10M\t*\t0\t0\tACGTACGTAC\tIIIIIIIIII\tRG:Z:rg1\nr2\t0\tchr1\t200\t60\t10M\t*\t0\t0\tTTTTAAAACC\tIIIIIIIIII\tRG:Z:rg1\n' > "${work}/reads.sam"
    count_file="${work}/count.txt"

    if output="$("${BINARY}" CountReads -I "${work}/reads.sam" -O "${count_file}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: %s CountReads exited %s: %s\n' \
            "${BINARY}" "${rc}" "${output}" >&2
        rm -rf "${work}"
        return 1
    fi

    if [[ ! -f "${count_file}" ]]; then
        printf 'FAIL: CountReads did not create output file: %s\n' \
            "${count_file}" >&2
        rm -rf "${work}"
        return 1
    fi

    actual="$(cat "${count_file}")"
    if [[ "${actual}" != "2" ]]; then
        printf 'FAIL: CountReads result mismatch: expected=<2> actual=<%s>\n' \
            "${actual}" >&2
        rm -rf "${work}"
        return 1
    fi

    rm -rf "${work}"
    printf 'PASS: CountReads counted 2 reads and wrote result to -O file\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_count_reads; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
