#!/bin/bash

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

WORKDIR=""
cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

require_binary() {
    local bin="$1"
    if ! command -v "${bin}" >/dev/null 2>&1; then
        printf 'FATAL: required binary not found in PATH: %s\n' "${bin}" >&2
        return 1
    fi
}

# Cactus is a pure-Python workflow orchestrator installed into the bundled
# virtualenv. The only authoritative version string at runtime is the installed
# distribution metadata (setup.py declares `name = "Cactus"`, `version = X`),
# so query it directly rather than relying on a non-existent `--version` flag.
test_version() {
    local out
    out="$(python3 -c 'import importlib.metadata as md; print(md.version("Cactus"))' 2>&1)"
    if [ "${out}" = "${EXPECTED_VERSION}" ]; then
        printf 'PASS: exact cactus version %s\n' "${out}"
        return 0
    fi
    printf 'FAIL: expected version %s, got <%s>\n' "${EXPECTED_VERSION}" "${out}"
    return 1
}

# `cactus-prepare --seqFileOnly` parses a progressive-cactus seqFile (a NEWICK
# species tree plus per-genome sequence paths) and rewrites an annotated output
# seqFile whose leaf paths are remapped into --outDir. It exercises real cactus
# code (SeqFile/MultiCactusTree parsing and config XML loading) without needing
# the external alignment binaries or any network access.
test_prepare_seqfile() {
    local seqfile outdir outseq out rc

    if ! require_binary "cactus-prepare"; then
        return 1
    fi

    WORKDIR="$(mktemp -d)"
    seqfile="${WORKDIR}/seqfile.txt"
    outdir="${WORKDIR}/out"
    outseq="${outdir}/seqfile.txt"

    cat > "${seqfile}" <<'SEQ_EOF'
(simHuman,simMouse);
simHuman input/simHuman.fa
simMouse input/simMouse.fa
SEQ_EOF

    out="$(cactus-prepare "${seqfile}" --outDir "${outdir}" --outSeqFile "${outseq}" --seqFileOnly 2>&1)"
    rc=$?
    if [ "${rc}" -ne 0 ]; then
        printf 'FAIL: cactus-prepare --seqFileOnly exited %s: %s\n' "${rc}" "${out}"
        return 1
    fi

    if [ ! -s "${outseq}" ]; then
        printf 'FAIL: cactus-prepare produced no output seqFile\n'
        return 1
    fi

    if ! grep -qF "simHuman" "${outseq}"; then
        printf 'FAIL: output seqFile missing leaf name simHuman\n'
        return 1
    fi
    if ! grep -qF "simMouse" "${outseq}"; then
        printf 'FAIL: output seqFile missing leaf name simMouse\n'
        return 1
    fi
    if ! grep -qF "${outdir}/simHuman.fa" "${outseq}"; then
        printf 'FAIL: output seqFile missing remapped path for simHuman\n'
        return 1
    fi
    if ! grep -qF "${outdir}/simMouse.fa" "${outseq}"; then
        printf 'FAIL: output seqFile missing remapped path for simMouse\n'
        return 1
    fi

    printf 'PASS: cactus-prepare parsed seqFile and produced annotated output seqFile\n'
    return 0
}

main() {
    local failures=0

    test_version         || failures=$((failures + 1))
    test_prepare_seqfile || failures=$((failures + 1))

    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"
