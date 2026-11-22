#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

PKGCONFIG_BIN="pkg-config"
LIB_DIR="/usr/local/lib"
LIB_VERSIONED="${LIB_DIR}/libz.so.1.4"
LIB_SO="${LIB_DIR}/libz.so"
LIB_MAJOR="${LIB_DIR}/libz.so.1"
LIB_STATIC="${LIB_DIR}/libz.a"
HEADER="${LIB_DIR%lib}/include/zlib.h"
PC_FILE="${LIB_DIR}/pkgconfig/zlib.pc"

test_version() {
    local output rc

    if ! command -v "${PKGCONFIG_BIN}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found: %s\n' "${PKGCONFIG_BIN}" >&2
        return 1
    fi

    if output="$("${PKGCONFIG_BIN}" --modversion zlib 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: pkg-config --modversion zlib exited %s: %s\n' \
            "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${output}"
}

test_pkgconfig_flags() {
    local output rc token

    if output="$("${PKGCONFIG_BIN}" --cflags --libs zlib 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: pkg-config --cflags --libs zlib exited %s: %s\n' \
            "${rc}" "${output}" >&2
        return 1
    fi

    for token in "-I/usr/local/include" "-L/usr/local/lib" "-lz"; do
        if [[ " ${output} " != *" ${token} "* ]]; then
            printf 'FAIL: pkg-config flags missing <%s>: <%s>\n' \
                "${token}" "${output}" >&2
            return 1
        fi
    done

    printf 'PASS: pkg-config flags: %s\n' "${output}"
}

test_installed_artifacts() {
    local target

    if [[ ! -f "${LIB_VERSIONED}" ]]; then
        printf 'FAIL: shared library not found: %s\n' "${LIB_VERSIONED}" >&2
        return 1
    fi

    if [[ ! -L "${LIB_MAJOR}" ]]; then
        printf 'FAIL: soname symlink not found: %s\n' "${LIB_MAJOR}" >&2
        return 1
    fi
    target="$(readlink "${LIB_MAJOR}")"
    if [[ "${target}" != "libz.so.1.4" ]]; then
        printf 'FAIL: soname symlink %s points to <%s>, expected <libz.so.1.4>\n' \
            "${LIB_MAJOR}" "${target}" >&2
        return 1
    fi

    if [[ ! -L "${LIB_SO}" ]]; then
        printf 'FAIL: linker symlink not found: %s\n' "${LIB_SO}" >&2
        return 1
    fi

    if [[ ! -f "${LIB_STATIC}" ]]; then
        printf 'FAIL: static library not found: %s\n' "${LIB_STATIC}" >&2
        return 1
    fi

    if [[ ! -f "${HEADER}" ]]; then
        printf 'FAIL: header not found: %s\n' "${HEADER}" >&2
        return 1
    fi

    if [[ ! -f "${PC_FILE}" ]]; then
        printf 'FAIL: pkg-config file not found: %s\n' "${PC_FILE}" >&2
        return 1
    fi

    printf 'PASS: installed artifacts present under /usr/local\n'
}

test_core_function() {
    local output rc

    if ! command -v python3 >/dev/null 2>&1; then
        printf 'FAIL: python3 not found\n' >&2
        return 1
    fi

    if output="$(python3 - "${EXPECTED_VERSION}" 2>&1 <<'PY'
import ctypes
import sys

expected = sys.argv[1]
lib = ctypes.CDLL("/usr/local/lib/libz.so.1.4")

lib.zlibVersion.restype = ctypes.c_char_p
ver = lib.zlibVersion().decode("ascii")
if ver != expected:
    sys.exit("zlibVersion mismatch: expected=%r actual=%r" % (expected, ver))

lib.compressBound.argtypes = [ctypes.c_ulong]
lib.compressBound.restype = ctypes.c_ulong
lib.compress2.argtypes = [
    ctypes.c_char_p,
    ctypes.POINTER(ctypes.c_ulong),
    ctypes.c_char_p,
    ctypes.c_ulong,
    ctypes.c_int,
]
lib.compress2.restype = ctypes.c_int
lib.uncompress.argtypes = [
    ctypes.c_char_p,
    ctypes.POINTER(ctypes.c_ulong),
    ctypes.c_char_p,
    ctypes.c_ulong,
]
lib.uncompress.restype = ctypes.c_int

data = b"zlib compression round-trip functional test\n" * 500
src_len = len(data)
bound = lib.compressBound(src_len)
comp = ctypes.create_string_buffer(bound)
comp_len = ctypes.c_ulong(bound)
rc = lib.compress2(comp, ctypes.byref(comp_len), data, src_len, 6)
if rc != 0:
    sys.exit("compress2 failed: rc=%d" % rc)

out = ctypes.create_string_buffer(src_len)
out_len = ctypes.c_ulong(src_len)
rc = lib.uncompress(out, ctypes.byref(out_len), comp, comp_len.value)
if rc != 0:
    sys.exit("uncompress failed: rc=%d" % rc)

if out.raw[:out_len.value] != data:
    sys.exit("round-trip mismatch: decompressed data differs from source")

print("zlibVersion=%s compress/uncompress round-trip ok (%d bytes)" % (ver, src_len))
PY
)"; then
        :
    else
        rc=$?
        printf 'FAIL: zlib core function test exited %s: %s\n' \
            "${rc}" "${output}" >&2
        return 1
    fi

    printf 'PASS: core compression round-trip: %s\n' "${output}"
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_pkgconfig_flags; then
        failures=$((failures + 1))
    fi
    if ! test_installed_artifacts; then
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