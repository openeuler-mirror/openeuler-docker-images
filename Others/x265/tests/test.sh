#!/bin/bash

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

X265_BIN="x265"
WORKDIR=""

cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_version() {
    local out ver

    if ! command -v "${X265_BIN}" >/dev/null 2>&1; then
        echo "FAIL: x265 binary not found in PATH" >&2
        return 1
    fi

    out="$("${X265_BIN}" --version 2>&1 || true)"

    if [[ "${out}" =~ HEVC\ encoder\ version\ ([0-9]+\.[0-9]+) ]]; then
        ver="${BASH_REMATCH[1]}"
    else
        echo "FAIL: cannot parse version from 'x265 --version' output: ${out}" >&2
        return 1
    fi

    if [[ "${ver}" != "${EXPECTED_VERSION}" ]]; then
        echo "FAIL: version mismatch: expected=<${EXPECTED_VERSION}> actual=<${ver}>" >&2
        return 1
    fi

    echo "PASS: exact x265 version ${ver}"
}

test_encode() {
    local input="${WORKDIR}/input.yuv"
    local output="${WORKDIR}/output.hevc"
    local out magic

    if ! dd if=/dev/zero of="${input}" bs=6144 count=10 2>/dev/null; then
        echo "FAIL: cannot create synthetic 64x64 I420 input" >&2
        return 1
    fi

    out="$("${X265_BIN}" --input "${input}" --input-res 64x64 --fps 25 \
        --frames 10 --preset ultrafast --pools none --output "${output}" 2>&1 || true)"

    if [ ! -s "${output}" ]; then
        echo "FAIL: encoder produced no non-empty bitstream: ${out}" >&2
        return 1
    fi

    magic="$(od -An -tx1 -N6 "${output}" 2>/dev/null | tr -d ' \n')"
    if [ "${magic}" != "000000014001" ]; then
        echo "FAIL: output lacks HEVC VPS start code: ${magic}" >&2
        return 1
    fi

    echo "PASS: encoded 10 frames to HEVC bitstream (VPS start code)"
}

main() {
    local failures=0

    WORKDIR="$(mktemp -d)"
    if [ -z "${WORKDIR}" ] || [ ! -d "${WORKDIR}" ]; then
        echo "FATAL: cannot create temporary working directory" >&2
        return 1
    fi

    test_version || failures=$((failures + 1))
    test_encode  || failures=$((failures + 1))

    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        return 0
    fi

    echo "TESTS_FAILED: ${failures} failure(s)" >&2
    return 1
}

main "$@"