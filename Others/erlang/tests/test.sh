#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# The Dockerfile builds OTP with ./configure --prefix=/usr/local, so the
# runtime executables are installed by `make install` under /usr/local/bin
# and the OTP root is /usr/local/lib/erlang.
ERL_BIN="/usr/local/bin/erl"
ERLC_BIN="/usr/local/bin/erlc"
WORKDIR=""

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_version() {
    local output rc major full

    for bin in "${ERL_BIN}" "${ERLC_BIN}"; do
        if [[ ! -x "${bin}" ]]; then
            printf 'FAIL: required runtime binary missing or not executable: %s\n' "${bin}" >&2
            return 1
        fi
    done

    # Erlang/OTP has no erlang:system_info/1 argument that reports the exact
    # OTP version; the documented way to retrieve it from an installed OTP
    # development system is to read
    #   <OTP root>/releases/<otp_release>/OTP_VERSION
    # where <OTP root> is code:root_dir() and <otp_release> is
    # erlang:system_info(otp_release).
    if output="$("${ERL_BIN}" -noshell -eval '
        {ok, Bin} = file:read_file(filename:join([
            code:root_dir(),
            "releases",
            erlang:system_info(otp_release),
            "OTP_VERSION"])),
        io:format("~s ~s~n", [
            erlang:system_info(otp_release),
            string:trim(binary_to_list(Bin))]),
        halt().
    ' 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: erl version query exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ ! "${output}" =~ ^([0-9]+)[[:space:]]+([0-9]+(\.[0-9]+)+)$ ]]; then
        printf 'FAIL: unexpected version output: <%s>\n' "${output}" >&2
        return 1
    fi
    major="${BASH_REMATCH[1]}"
    full="${BASH_REMATCH[2]}"

    if [[ "${major}" != "${EXPECTED_VERSION%%.*}" ]]; then
        printf 'FAIL: OTP release mismatch: expected major=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION%%.*}" "${major}" >&2
        return 1
    fi

    if [[ "${full}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: OTP version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${full}" >&2
        return 1
    fi

    printf 'PASS: exact OTP version: %s (release %s)\n' "${full}" "${major}"
}

test_core_function() {
    local out rc

    WORKDIR="$(mktemp -d)" || {
        printf 'FAIL: could not create temporary working directory\n' >&2
        return 1
    }

    # Official usage example: compile and run an Erlang module (README.md).
    cat > "${WORKDIR}/hello.erl" <<'EOF'
-module(hello).
-export([world/0]).

world() -> io:format("Hello, world~n").
EOF

    if out="$("${ERLC_BIN}" -o "${WORKDIR}" "${WORKDIR}/hello.erl" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: erlc compile exited %s: %s\n' "${rc}" "${out}" >&2
        return 1
    fi

    if [[ ! -f "${WORKDIR}/hello.beam" ]]; then
        printf 'FAIL: erlc did not produce hello.beam in %s\n' "${WORKDIR}" >&2
        return 1
    fi

    if out="$("${ERL_BIN}" -noshell -pa "${WORKDIR}" -eval 'hello:world(), halt().' 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: erl module execution exited %s: %s\n' "${rc}" "${out}" >&2
        return 1
    fi

    if [[ "${out}" != "Hello, world" ]]; then
        printf 'FAIL: module output mismatch: expected=<Hello, world> actual=<%s>\n' \
            "${out}" >&2
        return 1
    fi

    printf 'PASS: compiled and executed an Erlang module: %s\n' "${out}"
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
