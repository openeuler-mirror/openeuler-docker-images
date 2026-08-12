#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# RSEM v1.3.3 upstream ships rsem_perl_utils.pm with the version string still
# set to "RSEM v1.3.1" (the "Update version info here" marker was not bumped
# between v1.3.1 and v1.3.3; see the pinned v1.3.3 source). Therefore
# `rsem-calculate-expression --version` reports exactly
# "Current version: RSEM v1.3.1" for the v1.3.3 release. The assertion below is
# a byte-for-byte match against that pinned upstream value: any other output
# means a different RSEM revision is installed.
EXPECTED_REPORTED_VERSION="Current version: RSEM v1.3.1"

BINARY="rsem-calculate-expression"

test_version() {
    local output rc

    if ! command -v "${BINARY}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found: %s\n' "${BINARY}" >&2
        return 1
    fi

    if output="$("${BINARY}" --version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: version command exited %s: %s\n' \
            "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_REPORTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_REPORTED_VERSION}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact reported version (%s reports %s)\n' \
        "${EXPECTED_VERSION}" "${output}"
}

test_prepare_reference() {
    local tmpdir rc output f

    tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/rsem-prepare-reference.XXXXXX")"

    cat > "${tmpdir}/transcripts.fa" <<'EOF'
>tx1
ACGTACGTACGTACGTACGTACGTACGTACGT
>tx2
TGCAACGTACGTACGTACGTACGTACGTACGTACGT
EOF

    if output="$(cd "${tmpdir}" && rsem-prepare-reference transcripts.fa test_ref 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: rsem-prepare-reference exited %s: %s\n' \
            "${rc}" "${output}" >&2
        rm -rf "${tmpdir}"
        return 1
    fi

    for f in test_ref.grp test_ref.ti test_ref.seq \
             test_ref.transcripts.fa test_ref.idx.fa test_ref.n2g.idx.fa; do
        if [[ ! -s "${tmpdir}/${f}" ]]; then
            printf 'FAIL: generated reference file missing or empty: %s\n' "${f}" >&2
            rm -rf "${tmpdir}"
            return 1
        fi
    done

    # write-then-read: the input transcripts must be present in the aligner
    # reference FASTA produced by the rsem-preref step.
    if ! grep -q '^>tx1' "${tmpdir}/test_ref.idx.fa" || \
       ! grep -q '^>tx2' "${tmpdir}/test_ref.idx.fa"; then
        printf 'FAIL: input transcripts not found in %s\n' "${tmpdir}/test_ref.idx.fa" >&2
        rm -rf "${tmpdir}"
        return 1
    fi

    rm -rf "${tmpdir}"
    printf 'PASS: rsem-prepare-reference data path\n'
}

test_build_read_index() {
    local tmpdir rc output

    tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/rsem-build-read-index.XXXXXX")"

    cat > "${tmpdir}/reads.fa" <<'EOF'
>read1
ACGTACGTACGTACGTACGTACGTACGTACGT
>read2
TGCAACGTACGTACGTACGTACGTACGTACGT
>read3
ACGTACGTACGTACGTACGTACGTACGTACGT
EOF

    if output="$(cd "${tmpdir}" && rsem-build-read-index 16 0 0 reads.fa 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: rsem-build-read-index exited %s: %s\n' \
            "${rc}" "${output}" >&2
        rm -rf "${tmpdir}"
        return 1
    fi

    if [[ ! -s "${tmpdir}/reads.fa.ridx" ]]; then
        printf 'FAIL: read index file missing or empty: %s\n' "${tmpdir}/reads.fa.ridx" >&2
        rm -rf "${tmpdir}"
        return 1
    fi

    rm -rf "${tmpdir}"
    printf 'PASS: rsem-build-read-index data path\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_prepare_reference; then
        failures=$((failures + 1))
    fi
    if ! test_build_read_index; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
