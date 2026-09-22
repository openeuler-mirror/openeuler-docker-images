#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

PREFIX="/usr/local"
MFEM_HEADER="${PREFIX}/include/mfem/config/config.hpp"
MFEM_LIB="${PREFIX}/lib/libmfem.a"
MFEM_EX1="${PREFIX}/share/mfem/examples/ex1"
MFEM_MESH="${PREFIX}/share/mfem/data/star.mesh"

WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/mfem-test.XXXXXX")"
trap 'rm -rf "${WORKDIR}"' EXIT

test_install_artifacts() {
    local f missing=0

    for f in "${MFEM_LIB}" "${MFEM_EX1}" "${MFEM_MESH}" "${MFEM_HEADER}"; do
        if [[ ! -e "${f}" ]]; then
            printf 'FAIL: expected installed artifact missing: %s\n' "${f}" >&2
            missing=1
        fi
    done

    if (( missing )); then
        return 1
    fi

    printf 'PASS: installed library, example binary, mesh data and config header present\n'
}

test_version() {
    local line reported="" found=0

    while IFS= read -r line; do
        case "${line}" in
            '#define MFEM_VERSION_STRING '*)
                reported="${line##*MFEM_VERSION_STRING }"
                reported="${reported%\"}"
                reported="${reported#\"}"
                found=1
                break
                ;;
        esac
    done < "${MFEM_HEADER}"

    if (( ! found )); then
        printf 'FAIL: no "#define MFEM_VERSION_STRING" entry in %s\n' \
            "${MFEM_HEADER}" >&2
        return 1
    fi

    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${reported}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${reported}"
}

test_example1_laplace() {
    local output rc line first=""
    local expected_unknowns="Number of finite element unknowns: 20801"
    local expected_system="Size of linear system: 20801"
    local refined_mesh="${WORKDIR}/refined.mesh"
    local solution="${WORKDIR}/sol.gf"
    local unknowns_seen=0 system_seen=0

    if output="$(cd "${WORKDIR}" && "${MFEM_EX1}" -no-vis -m "${MFEM_MESH}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: ex1 -no-vis -m star.mesh exited %s\n%s\n' \
            "${rc}" "${output}" >&2
        return 1
    fi

    while IFS= read -r line; do
        if [[ "${line}" == "${expected_unknowns}" ]]; then
            unknowns_seen=1
        fi
        if [[ "${line}" == "${expected_system}" ]]; then
            system_seen=1
        fi
    done <<< "${output}"

    if (( ! unknowns_seen )); then
        printf 'FAIL: ex1 did not report <%s>\n' "${expected_unknowns}" >&2
        printf 'ex1 output was:\n%s\n' "${output}" >&2
        return 1
    fi

    if (( ! system_seen )); then
        printf 'FAIL: ex1 did not report <%s>\n' "${expected_system}" >&2
        printf 'ex1 output was:\n%s\n' "${output}" >&2
        return 1
    fi

    if [[ ! -s "${refined_mesh}" ]]; then
        printf 'FAIL: ex1 did not write a non-empty refined mesh: %s\n' \
            "${refined_mesh}" >&2
        return 1
    fi

    if ! IFS= read -r first < "${refined_mesh}"; then
        printf 'FAIL: cannot read refined mesh header: %s\n' \
            "${refined_mesh}" >&2
        return 1
    fi

    if [[ "${first}" != "MFEM mesh v1.0" ]]; then
        printf 'FAIL: refined mesh header mismatch: <%s>\n' "${first}" >&2
        return 1
    fi

    if [[ ! -s "${solution}" ]]; then
        printf 'FAIL: ex1 did not write a non-empty solution field: %s\n' \
            "${solution}" >&2
        return 1
    fi

    printf 'PASS: ex1 assembled/solved the Laplace problem (%s) and wrote solution files\n' \
        "${expected_unknowns#Number of finite element unknowns: }"
}

main() {
    local failures=0

    if ! test_install_artifacts; then
        failures=$((failures + 1))
    fi
    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_example1_laplace; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
