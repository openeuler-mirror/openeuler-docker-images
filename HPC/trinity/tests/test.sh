#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

BINARY="Trinity"
EXPECTED_VERSION_LINE="Trinity version: Trinity-v${EXPECTED_VERSION}"

test_version() {
    local output rc version_line

    if ! command -v "${BINARY}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found: %s\n' "${BINARY}" >&2
        return 1
    fi

    if output="$("${BINARY}" --version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: %s --version exited %s: %s\n' \
            "${BINARY}" "${rc}" "${output}" >&2
        return 1
    fi

    version_line="$(printf '%s\n' "${output}" | grep -m1 -E '^Trinity version: ')"
    if [[ -z "${version_line}" ]]; then
        printf 'FAIL: no version line in %s --version output\n' "${BINARY}" >&2
        printf -- '--- output ---\n%s\n' "${output}" >&2
        return 1
    fi

    if [[ "${version_line}" != "${EXPECTED_VERSION_LINE}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION_LINE}" "${version_line}" >&2
        return 1
    fi

    printf 'PASS: exact reported version (%s)\n' "${version_line}"
}

test_assembly() {
    local tmpdir output rc fasta stats n maxlen

    tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/trinity-assembly.XXXXXX")"

    if ! python3 - "${tmpdir}/reads.fa" <<'PYEOF'
import random, sys
random.seed(42)
out = sys.argv[1]
bases = "ACGT"
ref = "".join(random.choice(bases) for _ in range(400))
read_len = 100
step = 4
reads = [ref[i:i + read_len] for i in range(0, len(ref) - read_len + 1, step)]
with open(out, "w") as fh:
    for j, r in enumerate(reads):
        fh.write(">read_%d\n%s\n" % (j, r))
PYEOF
    then
        printf 'FAIL: failed to generate synthetic reads\n' >&2
        rm -rf "${tmpdir}"
        return 1
    fi

    if ! output="$(cd "${tmpdir}" && timeout 900 "${BINARY}" \
        --seqType fa \
        --single reads.fa \
        --max_memory 1G \
        --CPU 1 \
        --no_normalize_reads \
        --no_salmon \
        --no_version_check \
        --min_contig_length 100 2>&1)"; then
        rc=$?
        printf 'FAIL: %s assembly exited %s\n' "${BINARY}" "${rc}" >&2
        printf -- '--- Trinity output ---\n%s\n' "${output}" >&2
        rm -rf "${tmpdir}"
        return 1
    fi

    fasta="${tmpdir}/trinity_out_dir.Trinity.fasta"
    if [[ ! -s "${fasta}" ]]; then
        printf 'FAIL: assembly fasta missing or empty: %s\n' "${fasta}" >&2
        printf -- '--- Trinity output ---\n%s\n' "${output}" >&2
        rm -rf "${tmpdir}"
        return 1
    fi

    if ! stats="$(python3 - "${fasta}" <<'PYEOF'
import sys
path = sys.argv[1]
seqs = []
buf = []
for line in open(path):
    line = line.rstrip("\n")
    if line.startswith(">"):
        if buf:
            seqs.append("".join(buf))
            buf = []
    else:
        buf.append(line.strip())
if buf:
    seqs.append("".join(buf))
maxlen = max((len(s) for s in seqs), default=0)
print(len(seqs), maxlen)
PYEOF
)"; then
        printf 'FAIL: failed to inspect assembly fasta\n' >&2
        rm -rf "${tmpdir}"
        return 1
    fi

    n="${stats%% *}"
    maxlen="${stats##* }"

    if [[ -z "${n}" || "${n}" -lt 1 ]]; then
        printf 'FAIL: no transcripts assembled in %s\n' "${fasta}" >&2
        rm -rf "${tmpdir}"
        return 1
    fi

    if [[ -z "${maxlen}" || "${maxlen}" -lt 100 ]]; then
        printf 'FAIL: longest transcript too short (expected >=100, got %s)\n' "${maxlen}" >&2
        rm -rf "${tmpdir}"
        return 1
    fi

    rm -rf "${tmpdir}"
    printf 'PASS: de novo assembly produced %s transcript(s), longest %s nt\n' \
        "${n}" "${maxlen}"
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_assembly; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"