#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

FUSERMOUNT3_BIN="/usr/local/bin/fusermount3"
MOUNT_FUSE3_BIN="/usr/local/sbin/mount.fuse3"
LIBDIR="/usr/local/lib"

resolve_bin() {
    local name="$1" path="$2"
    if command -v "${name}" >/dev/null 2>&1; then
        printf '%s\n' "${name}"
        return 0
    fi
    if [ -x "${path}" ]; then
        printf '%s\n' "${path}"
        return 0
    fi
    return 1
}

test_version() {
    local fuser output rc expected
    fuser="$(resolve_bin fusermount3 "${FUSERMOUNT3_BIN}")" || {
        printf 'FAIL: fusermount3 not found\n' >&2
        return 1
    }
    if output="$("${fuser}" -V 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: fusermount3 -V exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi
    expected="fusermount3 version: ${EXPECTED_VERSION}"
    if [ "${output}" != "${expected}" ]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${output}" >&2
        return 1
    fi
    printf 'PASS: exact version: %s\n' "${output}"
}

test_library() {
    local soname versioned
    soname="libfuse3.so.3"
    versioned="libfuse3.so.${EXPECTED_VERSION}"
    if [ ! -e "${LIBDIR}/${versioned}" ]; then
        printf 'FAIL: versioned shared library missing: %s\n' \
            "${LIBDIR}/${versioned}" >&2
        return 1
    fi
    if [ ! -e "${LIBDIR}/${soname}" ]; then
        printf 'FAIL: library SONAME missing: %s\n' \
            "${LIBDIR}/${soname}" >&2
        return 1
    fi
    printf 'PASS: libfuse3 shared library %s present with SONAME %s\n' \
        "${versioned}" "${soname}"
}

test_mount_helper() {
    local mf output rc
    mf="$(resolve_bin mount.fuse3 "${MOUNT_FUSE3_BIN}")" || {
        printf 'FAIL: mount.fuse3 not found\n' >&2
        return 1
    }
    if output="$("${mf}" 2>&1)"; then
        rc=0
    else
        rc=$?
    fi
    if [ "${rc}" -ne 1 ]; then
        printf 'FAIL: mount.fuse3 without arguments exited %s (expected 1): %s\n' \
            "${rc}" "${output}" >&2
        return 1
    fi
    case "${output}" in
        *"destination [-t type] [-o opt[,opts...]]"*) ;;
        *)
            printf 'FAIL: mount.fuse3 usage output unexpected: %s\n' "${output}" >&2
            return 1
            ;;
    esac
    printf 'PASS: mount.fuse3 loads libfuse3 and reports usage\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_library; then
        failures=$((failures + 1))
    fi
    if ! test_mount_helper; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
