#!/bin/bash

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# nemo is installed to /usr/local/bin by meson (default --prefix=/usr/local).
# The Dockerfile does not prepend that directory to PATH, so resolve the binary
# from PATH and fall back to the documented install location.
NEMO_BIN="$(command -v nemo 2>/dev/null || true)"
if [ -z "${NEMO_BIN}" ] && [ -x /usr/local/bin/nemo ]; then
    NEMO_BIN="/usr/local/bin/nemo"
fi

test_version() {
    local out expected

    if [ -z "${NEMO_BIN}" ]; then
        echo "FAIL: nemo binary not found in PATH or /usr/local/bin"
        return 1
    fi

    out="$(xvfb-run -a "${NEMO_BIN}" --version 2>&1 || true)"

    # nemo --version prints "nemo <version>" (src/nemo-main-application.c:
    # g_print ("nemo " VERSION "\n")). Release tags carry a channel suffix
    # (e.g. "-unstable") that is not part of meson's project version, so the
    # binary omits it (meson.build for tag 6.7.9-unstable declares version
    # '6.7.9'). Normalise the expected image version the same way, then require
    # an exact, complete match of the reported string.
    expected="${EXPECTED_VERSION%-unstable}"

    if [ "${out}" = "nemo ${expected}" ]; then
        echo "PASS: exact version: ${out}"
        return 0
    fi
    echo "FAIL: expected version 'nemo ${expected}', got '${out}'"
    return 1
}

test_help() {
    local out

    if [ -z "${NEMO_BIN}" ]; then
        echo "FAIL: nemo binary not found in PATH or /usr/local/bin"
        return 1
    fi

    out="$("${NEMO_BIN}" --help 2>&1 || true)"

    # A working build must print its GOptionEntry options in the --help summary
    # (the table in src/nemo-main-application.c registers --version and --quit).
    if printf '%s' "${out}" | grep -q -- '--version' \
        && printf '%s' "${out}" | grep -q -- '--quit'; then
        echo "PASS: --help lists documented options (--version, --quit)"
        return 0
    fi
    echo "FAIL: --help output missing expected options"
    return 1
}

main() {
    local failures=0

    test_version || failures=$((failures + 1))
    test_help    || failures=$((failures + 1))

    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        return 0
    fi
    echo "TESTS_FAILED: ${failures} failure(s)"
    return 1
}

main "$@"
