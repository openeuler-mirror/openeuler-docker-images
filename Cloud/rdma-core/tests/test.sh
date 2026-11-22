#!/bin/bash
# KunpengTest functional test for rdma-core.
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only. Injected env vars include
# EXPECTED_VERSION (the image version). The tests assert that the installed
# rdma-core tools report the exact package version and that the libibverbs
# device-discovery data path runs and yields a well-formed device count.
#
# Application commands and their semantics are derived from the rdma-core
# v66.0 sources:
#   - `ibstat --version` prints "<prog> BUILD VERSION: <PACKAGE_VERSION>" to
#     stderr and exits 0 (infiniband-diags/ibdiag_common.c).
#   - `ibv_devinfo --list` enumerates the HCA list via ibv_get_device_list() and
#     prints "<N> HCA(s) found:" (libibverbs/examples/devinfo.c).

set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

find_bin() {
    local name="$1" p
    command -v "${name}" 2>/dev/null && return 0
    for p in /usr/bin/"${name}" /usr/local/bin/"${name}" /bin/"${name}" \
             /usr/sbin/"${name}" /usr/local/sbin/"${name}" /sbin/"${name}"; do
        if [ -x "${p}" ]; then
            printf '%s\n' "${p}"
            return 0
        fi
    done
    return 1
}

test_version() {
    local bin output rc ver_line ver

    if ! bin="$(find_bin "ibstat")"; then
        printf 'FAIL: binary not found: ibstat\n' >&2
        return 1
    fi

    if output="$("${bin}" --version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: ibstat --version exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    # The version line is "<argv0> BUILD VERSION: <version>". Extract the
    # value after the "BUILD VERSION: " marker and strip all whitespace, then
    # require an exact match against EXPECTED_VERSION.
    if [[ "${output}" != *'BUILD VERSION:'* ]]; then
        printf 'FAIL: no BUILD VERSION in ibstat output: %s\n' "${output}" >&2
        return 1
    fi
    ver_line="${output#*'BUILD VERSION:'}"
    ver_line="${ver_line#[[:space:]]}"
    ver="${ver_line//[[:space:]]/}"

    if [[ "${ver}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${ver}" >&2
        return 1
    fi

    printf 'PASS: exact version %s\n' "${ver}"
}

test_core_function() {
    local bin output rc

    if ! bin="$(find_bin "ibv_devinfo")"; then
        printf 'FAIL: binary not found: ibv_devinfo\n' >&2
        return 1
    fi

    if output="$("${bin}" --list 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: ibv_devinfo --list exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    # ibv_devinfo --list drives the libibverbs device discovery path and prints
    # a first line of the form "<N> HCA(s) found:" followed by device names.
    # Verify the command produced a well-formed device count line.
    if [[ ! "${output}" =~ ^[0-9]+[[:space:]]+HCA(s)?[[:space:]]+found: ]]; then
        printf 'FAIL: unexpected ibv_devinfo --list output: %s\n' "${output}" >&2
        return 1
    fi

    printf 'PASS: device enumeration produced a valid HCA count\n'
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