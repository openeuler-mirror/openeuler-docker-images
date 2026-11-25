#!/bin/bash
# KunpengTest functional test for webbench (HTTP benchmarking tool).
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version dir name), DOCKER_NAMESPACE, DOCKER_PACKAGE,
# DOCKER_TAG, DOCKER_IMAGE.
#
# WebBench is a lightweight forking HTTP benchmark. Upstream pins the program
# version string to "1.5" in webbench.c (PROGRAM_VERSION), which is what
# `webbench --version` always prints. Some image tags are named after a git
# commit (e.g. "b1acf3c..."), which the compiled binary cannot report, so for
# commit-tagged images the version case only asserts the version flag works.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

APP_BIN="webbench"
WORKDIR=""
SERVER_PID=""

cleanup() {
    if [ -n "${SERVER_PID}" ]; then
        kill "${SERVER_PID}" 2>/dev/null
        kill -9 "${SERVER_PID}" 2>/dev/null
        wait "${SERVER_PID}" 2>/dev/null
    fi
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

webbench_bin() {
    command -v "${APP_BIN}" 2>/dev/null && return 0
    [ -x "/usr/local/bin/${APP_BIN}" ] && { printf '/usr/local/bin/%s\n' "${APP_BIN}"; return 0; }
    return 1
}

version_matches() {
    local token="$1" part
    token="${token#v}"; token="${token#V}"
    [ "${token}" = "${EXPECTED_VERSION}" ] && return 0
    while IFS= read -r part; do
        [ -n "${part}" ] || continue
        part="${part#v}"; part="${part#V}"
        [ "${part}" = "${EXPECTED_VERSION}" ] && return 0
    done < <(printf '%s\n' "${token}" | tr '/-' '\n')
    if [[ "${token}" =~ ^([0-9]+(\.[0-9A-Za-z]+)+) ]] && [ "${BASH_REMATCH[1]}" = "${EXPECTED_VERSION}" ]; then
        return 0
    fi
    return 1
}

test_binary() {
    local bin
    bin="$(webbench_bin)"
    if [ -n "${bin}" ] && [ -x "${bin}" ]; then
        printf 'PASS: %s binary present and executable at %s\n' "${APP_BIN}" "${bin}"
        return 0
    fi
    printf 'FAIL: %s binary not found or not executable\n' "${APP_BIN}"
    return 1
}

test_help() {
    local bin out rc
    bin="$(webbench_bin)" || {
        printf 'FATAL: %s binary missing\n' "${APP_BIN}"
        return 1
    }
    out="$("${bin}" --help 2>&1)"; rc=$?
    if [ "${rc}" -eq 2 ] \
       && printf '%s' "${out}" | grep -qF 'webbench [option]... URL' \
       && printf '%s' "${out}" | grep -qF -- '-c|--clients'; then
        printf 'PASS: --help prints usage and exits 2\n'
        return 0
    fi
    printf 'FAIL: --help exit %s with unexpected output: %s\n' "${rc}" \
        "$(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-300)"
    return 1
}

test_version() {
    local bin out token printed
    bin="$(webbench_bin)" || {
        printf 'FATAL: %s binary missing\n' "${APP_BIN}"
        return 1
    }
    out="$("${bin}" --version 2>&1)"
    if [ -z "${out}" ]; then
        printf 'FAIL: %s produced no version output\n' "${APP_BIN}"
        return 1
    fi
    printed="$(printf '%s' "${out}" | tr -d '[:space:]')"
    if printf '%s' "${EXPECTED_VERSION}" | grep -Eq '^[0-9a-fA-F]{7,40}$'; then
        printf 'PASS: %s reports program version %s (commit-tagged image %s)\n' \
            "${APP_BIN}" "${printed}" "${EXPECTED_VERSION}"
        return 0
    fi
    for token in $(printf '%s\n' "${out}" | tr -c 'A-Za-z0-9._+-' ' '); do
        if version_matches "${token}"; then
            printf 'PASS: %s reports version %s\n' "${APP_BIN}" "${EXPECTED_VERSION}"
            return 0
        fi
    done
    printf 'FAIL: expected %s version %s, got: %s\n' "${APP_BIN}" "${EXPECTED_VERSION}" \
        "$(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-300)"
    return 1
}

test_benchmark() {
    local bin out port i ready
    bin="$(webbench_bin)" || {
        printf 'FATAL: %s binary missing\n' "${APP_BIN}"
        return 1
    }
    if ! command -v python3 >/dev/null 2>&1; then
        printf 'FAIL: python3 not found, cannot start the local HTTP server\n'
        return 1
    fi

    WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/webbench-test.XXXXXX")"
    printf 'webbench-probe-ok\n' > "${WORKDIR}/index.html"

    port="$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1", 0)); print(s.getsockname()[1]); s.close()' 2>/dev/null)"
    if [ -z "${port}" ]; then
        printf 'FAIL: could not allocate a free local port for the HTTP server\n'
        return 1
    fi

    python3 -m http.server "${port}" --bind 127.0.0.1 --directory "${WORKDIR}" >/dev/null 2>&1 &
    SERVER_PID=$!

    ready=0
    i=0
    while [ "${i}" -lt 30 ]; do
        if python3 -c 'import socket,sys; s=socket.socket(); s.settimeout(1); s.connect(("127.0.0.1", int(sys.argv[1]))); s.close()' "${port}" 2>/dev/null; then
            ready=1
            break
        fi
        i=$((i + 1))
        sleep 1
    done

    if [ "${ready}" -ne 1 ]; then
        printf 'FAIL: local HTTP server did not become ready on port %s\n' "${port}"
        return 1
    fi

    out="$("${bin}" -c 1 -t 2 "http://127.0.0.1:${port}/index.html" 2>&1 || true)"

    if printf '%s' "${out}" | grep -qF 'Speed=' \
       && printf '%s' "${out}" | grep -Eq 'Requests: *[1-9][0-9]* susceed, 0 failed'; then
        printf 'PASS: benchmark served requests with 0 failed against local HTTP server\n'
        return 0
    fi
    printf 'FAIL: benchmark did not report successful requests: %s\n' \
        "$(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-300)"
    return 1
}

main() {
    local failures=0
    test_binary    || failures=$((failures + 1))
    test_help      || failures=$((failures + 1))
    test_version   || failures=$((failures + 1))
    test_benchmark || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"