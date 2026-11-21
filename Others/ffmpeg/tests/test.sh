#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

FFMPEG="/usr/local/bin/ffmpeg"
FFPROBE="/usr/local/bin/ffprobe"

fail() {
    printf 'FAIL: %s\n' "$*" >&2
}

test_version() {
    local output first_line version

    if [[ ! -x "${FFMPEG}" ]]; then
        fail "ffmpeg binary not found or not executable: ${FFMPEG}"
        return 1
    fi

    if ! output="$("${FFMPEG}" -version 2>&1)"; then
        fail "ffmpeg -version exited non-zero: ${output}"
        return 1
    fi

    IFS= read -r first_line <<< "${output}"

    if [[ ! "${first_line}" =~ ^ffmpeg[[:space:]]+version[[:space:]]+([^[:space:]]+) ]]; then
        fail "unexpected ffmpeg -version first line: ${first_line}"
        return 1
    fi
    version="${BASH_REMATCH[1]}"

    if [[ "${version}" != "${EXPECTED_VERSION}" ]]; then
        fail "version mismatch: expected=<${EXPECTED_VERSION}> actual=<${version}>"
        return 1
    fi

    printf 'PASS: ffmpeg reports exact version %s\n' "${version}"
}

test_transcode_readback() {
    local outfile output expected

    if [[ ! -x "${FFPROBE}" ]]; then
        fail "ffprobe binary not found or not executable: ${FFPROBE}"
        return 1
    fi

    outfile="/tmp/ffmpeg-smoke-$$.mkv"

    if ! output="$("${FFMPEG}" -y -v error -f lavfi \
            -i testsrc=duration=1:size=64x64:rate=10 \
            -c:v ffv1 "${outfile}" 2>&1)"; then
        rm -f "${outfile}"
        fail "ffmpeg transcode (lavfi testsrc -> ffv1 mkv) exited non-zero: ${output}"
        return 1
    fi

    if [[ ! -s "${outfile}" ]]; then
        rm -f "${outfile}"
        fail "transcode produced no output file: ${outfile}"
        return 1
    fi

    if ! output="$("${FFPROBE}" -v error \
            -show_entries stream=codec_name,width,height \
            -of default=noprint_wrappers=1:nokey=1 "${outfile}" 2>&1)"; then
        rm -f "${outfile}"
        fail "ffprobe read-back exited non-zero: ${output}"
        return 1
    fi
    rm -f "${outfile}"

    expected=$'ffv1\n64\n64'
    if [[ "${output}" != "${expected}" ]]; then
        fail "read-back mismatch: expected=<codec_name=ffv1 width=64 height=64> actual=<${output}>"
        return 1
    fi

    printf 'PASS: ffmpeg transcode + ffprobe read-back (ffv1 64x64)\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_transcode_readback; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
