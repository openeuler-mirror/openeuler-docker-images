#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# The Dockerfile installs the lz4 CLI into /usr/local/bin (make install with
# default PREFIX=/usr/local, copied from /opt/lz4/usr/local/).
BINARY="/usr/local/bin/lz4"

WORKDIR=""

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

fail() {
    printf 'FAIL: %s\n' "$*" >&2
}

test_binary_and_version() {
    local version_output actual

    if [[ ! -x "${BINARY}" ]]; then
        fail "lz4 binary not found or not executable: ${BINARY}"
        return 1
    fi

    if ! version_output="$("${BINARY}" --version 2>&1)"; then
        fail "lz4 --version exited non-zero: ${version_output}"
        return 1
    fi

    # Upstream --version prints the WELCOME_MESSAGE banner, e.g.
    #   "*** lz4 v1.10.0 64-bit multithread, by Yann Collet ***"
    # Extract the exact vX.Y.Z token reported by the built binary.
    if [[ "${version_output}" != "*** "* ]]; then
        fail "unexpected lz4 --version banner: <${version_output}>"
        return 1
    fi

    if [[ "${version_output}" =~ v([0-9]+\.[0-9]+\.[0-9]+) ]]; then
        actual="${BASH_REMATCH[1]}"
    else
        fail "could not parse a vX.Y.Z version from: <${version_output}>"
        return 1
    fi

    if [[ "${actual}" != "${EXPECTED_VERSION}" ]]; then
        fail "version mismatch: expected=<${EXPECTED_VERSION}> actual=<${actual}>"
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${actual}"
}

test_roundtrip() {
    local src="${WORKDIR}/input.txt"
    local compressed="${WORKDIR}/input.txt.lz4"
    local restored="${WORKDIR}/restored.txt"
    local i src_sum dst_sum output

    for ((i = 0; i < 20000; i++)); do
        printf 'line-%d: the quick brown fox jumps over the lazy dog\n' "${i}"
    done > "${src}"

    if ! output="$("${BINARY}" -f "${src}" "${compressed}" 2>&1)"; then
        fail "compression exited non-zero: ${output}"
        return 1
    fi

    if [[ ! -s "${compressed}" ]]; then
        fail "compressed file missing or empty: ${compressed}"
        return 1
    fi

    if ! output="$("${BINARY}" -t "${compressed}" 2>&1)"; then
        fail "integrity test (-t) exited non-zero: ${output}"
        return 1
    fi

    if ! output="$("${BINARY}" -d -f "${compressed}" "${restored}" 2>&1)"; then
        fail "decompression exited non-zero: ${output}"
        return 1
    fi

    src_sum="$(sha256sum "${src}")"
    dst_sum="$(sha256sum "${restored}")"

    if [[ "${src_sum%% *}" != "${dst_sum%% *}" ]]; then
        fail "decompressed content differs from source"
        return 1
    fi

    printf 'PASS: compress / integrity-test / decompress roundtrip\n'
}

main() {
    local failures=0

    WORKDIR="$(mktemp -d)"
    if [[ ! -d "${WORKDIR}" ]]; then
        fail "cannot create temporary working directory"
        return 1
    fi

    if ! test_binary_and_version; then
        failures=$((failures + 1))
    fi
    if ! test_roundtrip; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
