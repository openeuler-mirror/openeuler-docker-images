#!/bin/bash

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

resolve_bin() {
    local name="$1" path=""
    if path="$(command -v "${name}" 2>/dev/null)"; then
        printf '%s\n' "${path}"
        return 0
    fi
    for candidate in \
        "/usr/local/bin/${name}" \
        "/usr/local/sbin/${name}" \
        "/usr/sbin/${name}" \
        "/sbin/${name}" \
        "/usr/bin/${name}" \
        "/bin/${name}"; do
        if [ -x "${candidate}" ]; then
            printf '%s\n' "${candidate}"
            return 0
        fi
    done
    return 1
}

test_version() {
    local bin out ver
    if ! bin="$(resolve_bin lfs)"; then
        echo "FAIL: lfs binary not found"
        return 1
    fi
    out="$("${bin}" --version 2>&1 || true)"
    ver="${out#* }"
    if [ "${ver}" = "${EXPECTED_VERSION}" ]; then
        echo "PASS: lfs reports exact version ${ver}"
        return 0
    fi
    echo "FAIL: expected lfs version '${EXPECTED_VERSION}', got '${out}'"
    return 1
}

test_lctl_version() {
    local bin out ver
    if ! bin="$(resolve_bin lctl)"; then
        echo "FAIL: lctl binary not found"
        return 1
    fi
    out="$("${bin}" --version 2>&1 || true)"
    ver="${out#* }"
    if [ "${ver}" = "${EXPECTED_VERSION}" ]; then
        echo "PASS: lctl reports exact version ${ver}"
        return 0
    fi
    echo "FAIL: expected lctl version '${EXPECTED_VERSION}', got '${out}'"
    return 1
}

test_command_table() {
    local bin out
    if ! bin="$(resolve_bin lfs)"; then
        echo "FAIL: lfs binary not found"
        return 1
    fi
    out="$("${bin}" list-commands 2>&1 || true)"
    if printf '%s\n' "${out}" | grep -q 'setstripe' &&
        printf '%s\n' "${out}" | grep -q 'getstripe' &&
        printf '%s\n' "${out}" | grep -q 'df'; then
        echo "PASS: lfs command table lists core layout/df subcommands"
        return 0
    fi
    echo "FAIL: lfs command table missing core subcommands"
    return 1
}

main() {
    local failures=0
    test_version || failures=$((failures + 1))
    test_lctl_version || failures=$((failures + 1))
    test_command_table || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        return 0
    fi
    echo "TESTS_FAILED: ${failures} failure(s)"
    return 1
}

main "$@"