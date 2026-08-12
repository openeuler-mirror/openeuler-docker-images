#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

PYTHON_FUNC_TEST="$(cat <<'PYEOF'
import os
import shutil
import tempfile

from pysam import AlignedSegment, AlignmentFile

tmpdir = tempfile.mkdtemp(prefix="pysam-functional-")
try:
    sam_path = os.path.join(tmpdir, "test.sam")

    header = {
        "HD": {"VN": "1.6", "SO": "unsorted"},
        "SQ": [
            {"SN": "chr1", "LN": 1000},
            {"SN": "chr2", "LN": 2000},
        ],
    }

    outfile = AlignmentFile(sam_path, "w", header=header)

    read = AlignedSegment()
    read.query_name = "read1"
    read.query_sequence = "AGCTTAGCTAGCTACCTATATCTTGGCTTAGAGCCCA"
    read.flag = 0
    read.reference_id = 0
    read.reference_start = 100
    read.mapping_quality = 20
    read.cigarstring = "37M"
    outfile.write(read)

    read2 = AlignedSegment()
    read2.query_name = "read2"
    read2.query_sequence = "GATCGATCGATCGATCGATCGATCGATCGATCG"
    read2.flag = 16
    read2.reference_id = 1
    read2.reference_start = 500
    read2.mapping_quality = 30
    read2.cigarstring = "33M"
    outfile.write(read2)
    outfile.close()

    infile = AlignmentFile(sam_path, "r")

    assert infile.references == ("chr1", "chr2"), \
        "unexpected header references: %s" % (infile.references,)
    assert infile.lengths == (1000, 2000), \
        "unexpected header lengths: %s" % (infile.lengths,)

    records = list(infile.fetch())
    infile.close()

    assert len(records) == 2, "expected 2 records, got %d" % len(records)

    by_name = {}
    for rec in records:
        by_name[rec.query_name] = rec

    r1 = by_name["read1"]
    assert r1.query_sequence == "AGCTTAGCTAGCTACCTATATCTTGGCTTAGAGCCCA", "read1 query_sequence"
    assert r1.flag == 0, "read1 flag: %d" % r1.flag
    assert r1.reference_id == 0, "read1 reference_id: %d" % r1.reference_id
    assert r1.reference_name == "chr1", "read1 reference_name: %r" % r1.reference_name
    assert r1.reference_start == 100, "read1 reference_start: %d" % r1.reference_start
    assert r1.mapping_quality == 20, "read1 mapping_quality: %d" % r1.mapping_quality
    assert r1.cigarstring == "37M", "read1 cigarstring: %r" % r1.cigarstring

    r2 = by_name["read2"]
    assert r2.query_sequence == "GATCGATCGATCGATCGATCGATCGATCGATCG", "read2 query_sequence"
    assert r2.flag == 16, "read2 flag: %d" % r2.flag
    assert r2.reference_id == 1, "read2 reference_id: %d" % r2.reference_id
    assert r2.reference_name == "chr2", "read2 reference_name: %r" % r2.reference_name
    assert r2.reference_start == 500, "read2 reference_start: %d" % r2.reference_start
    assert r2.mapping_quality == 30, "read2 mapping_quality: %d" % r2.mapping_quality
    assert r2.cigarstring == "33M", "read2 cigarstring: %r" % r2.cigarstring

    print("PASS: pysam AlignmentFile SAM write/read round-trip")
finally:
    shutil.rmtree(tmpdir, ignore_errors=True)
PYEOF
)"

test_version() {
    local output rc

    if ! command -v python3 >/dev/null 2>&1; then
        printf 'FAIL: python3 not found in runtime image\n' >&2
        return 1
    fi

    if output="$(python3 -c 'import pysam; print(pysam.__version__)' 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: pysam version query exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${output}"
}

test_core_function() {
    local output rc expected_output

    expected_output="PASS: pysam AlignmentFile SAM write/read round-trip"

    if output="$(python3 -c "${PYTHON_FUNC_TEST}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: pysam functional test exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != *"${expected_output}"* ]]; then
        printf 'FAIL: unexpected functional test output: %s\n' "${output}" >&2
        return 1
    fi

    printf 'PASS: core SAM write/read round-trip\n'
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
