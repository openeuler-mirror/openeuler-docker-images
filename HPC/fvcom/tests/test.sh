#!/bin/bash

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# FVCOM is an OpenMPI-linked Fortran binary. OpenMPI refuses to launch as root
# unless these are set; the harness runs the container as root by default.
export OMPI_ALLOW_RUN_AS_ROOT="${OMPI_ALLOW_RUN_AS_ROOT:-1}"
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM="${OMPI_ALLOW_RUN_AS_ROOT_CONFIRM:-1}"

FVCOM_BIN=""
WORKDIR=""

cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

resolve_binary() {
    FVCOM_BIN="$(command -v fvcom 2>/dev/null || true)"
    if [ -z "${FVCOM_BIN}" ] && [ -x /usr/local/bin/fvcom ]; then
        FVCOM_BIN="/usr/local/bin/fvcom"
    fi
    [ -n "${FVCOM_BIN}" ]
}

make_workdir() {
    if [ -z "${WORKDIR}" ]; then
        WORKDIR="$(mktemp -d)"
    fi
}

# Run a command with a bounded wait (no external `timeout` dependency).
# Combined stdout/stderr is written to the first argument; returns the exit
# status of the command, or 124 when the 30s bound is exceeded.
run_bounded() {
    local outfile="$1"
    shift
    local pid c rc
    "$@" >"${outfile}" 2>&1 &
    pid=$!
    c=0
    while kill -0 "${pid}" 2>/dev/null; do
        c=$((c + 1))
        if [ "${c}" -gt 30 ]; then
            kill "${pid}" 2>/dev/null
            wait "${pid}" 2>/dev/null
            return 124
        fi
        sleep 1
    done
    wait "${pid}"
    rc=$?
    return "${rc}"
}

test_version() {
    local out expected
    if ! resolve_binary; then
        echo "FAIL: fvcom binary not found"
        return 1
    fi
    expected="FVCOM_${EXPECTED_VERSION}"
    out="$(grep -aoE 'FVCOM_[0-9]+\.[0-9]+\.[0-9]+' "${FVCOM_BIN}" 2>/dev/null | head -n 1)"
    if [ -z "${out}" ]; then
        echo "FAIL: no FVCOM version token embedded in ${FVCOM_BIN}"
        return 1
    fi
    if [ "${out}" != "${expected}" ]; then
        echo "FAIL: version mismatch: expected=<${expected}> actual=<${out}>"
        return 1
    fi
    echo "PASS: exact version ${out}"
    return 0
}

test_help() {
    local outfile out
    if ! resolve_binary; then
        echo "FAIL: fvcom binary not found"
        return 1
    fi
    make_workdir
    outfile="${WORKDIR}/help.out"
    run_bounded "${outfile}" "${FVCOM_BIN}" --help
    out="$(cat "${outfile}" 2>/dev/null || true)"
    if printf '%s\n' "${out}" | grep -qF -- '--CASENAME=<YOUR_CASE> (REQUIRED)'; then
        echo "PASS: fvcom --help prints usage including required --CASENAME option"
        return 0
    fi
    echo "FAIL: fvcom --help did not print expected usage text"
    return 1
}

test_dynamic_deps() {
    local out
    if ! resolve_binary; then
        echo "FAIL: fvcom binary not found"
        return 1
    fi
    out="$(ldd "${FVCOM_BIN}" 2>&1 || true)"
    if printf '%s\n' "${out}" | grep -q -- 'not found'; then
        echo "FAIL: fvcom has unresolved shared library dependencies"
        return 1
    fi
    if ! printf '%s\n' "${out}" | grep -q -- 'libnetcdff'; then
        echo "FAIL: fvcom is not linked against libnetcdff"
        return 1
    fi
    echo "PASS: fvcom shared library dependencies resolve (libnetcdff linked)"
    return 0
}

main() {
    local failures=0
    test_version || failures=$((failures + 1))
    test_help || failures=$((failures + 1))
    test_dynamic_deps || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        return 0
    fi
    echo "TESTS_FAILED: ${failures} failure(s)"
    return 1
}

main "$@"
