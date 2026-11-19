#!/bin/bash
# KunpengTest functional test for petsc (version only).
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version dir name), DOCKER_NAMESPACE, DOCKER_PACKAGE,
# DOCKER_TAG, DOCKER_IMAGE.
#
# The image installs PETSc with `./configure --prefix=/usr/local/petsc` and
# exports PETSC_DIR=/usr/local/petsc, but never sets PKG_CONFIG_PATH, so
# `pkg-config --modversion PETSc` cannot find PETSc.pc.  Locate the .pc file
# (installed under the PETSC_DIR prefix) and extend PKG_CONFIG_PATH; when no
# .pc file was installed, fall back to the version macros in the installed
# include/petscversion.h.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

APP_NAME="petsc"
PETSC_DIR="${PETSC_DIR:-/usr/local/petsc}"
export PETSC_DIR

add_pkg_config_path() {
    local dir="$1"
    [ -n "${dir}" ] || return 0
    case ":${PKG_CONFIG_PATH:-}:" in
        *":${dir}:"*) ;;
        *) PKG_CONFIG_PATH="${dir}${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}" ;;
    esac
}

prepare_environment() {
    local pc dir
    for dir in "${PETSC_DIR}/lib/pkgconfig" "${PETSC_DIR}/lib64/pkgconfig" \
               "${PETSC_DIR}"/*/lib/pkgconfig "${PETSC_DIR}"/*/lib64/pkgconfig; do
        [ -f "${dir}/PETSc.pc" ] || continue
        add_pkg_config_path "${dir}"
    done
    pc="$(find "${PETSC_DIR}" -name 'PETSc.pc' -type f -print -quit 2>/dev/null || true)"
    if [ -n "${pc}" ]; then
        add_pkg_config_path "$(dirname "${pc}")"
    fi
    export PKG_CONFIG_PATH
}

find_bin() {
    local name="$1" p
    for p in "/usr/local/bin/${name}" "/usr/bin/${name}" "/bin/${name}" \
             "/usr/local/sbin/${name}" "/usr/sbin/${name}" "/sbin/${name}" \
             "/usr/local/petsc/bin/${name}"; do
        if [ -x "${p}" ]; then
            printf '%s\n' "${p}"
            return 0
        fi
    done
    command -v "${name}" 2>/dev/null && return 0
    return 1
}

petsc_header_version() {
    local header major minor sub
    header="${PETSC_DIR}/include/petscversion.h"
    [ -r "${header}" ] || return 1
    major="$(awk '$1 == "#define" && $2 == "PETSC_VERSION_MAJOR" {print $3; exit}' "${header}")"
    minor="$(awk '$1 == "#define" && $2 == "PETSC_VERSION_MINOR" {print $3; exit}' "${header}")"
    sub="$(awk '$1 == "#define" && $2 == "PETSC_VERSION_SUBMINOR" {print $3; exit}' "${header}")"
    if [ -z "${major}" ] || [ -z "${minor}" ] || [ -z "${sub}" ]; then
        return 1
    fi
    printf '%s.%s.%s\n' "${major}" "${minor}" "${sub}"
}

app_version_output() {
    local pc out
    pc="$(find_bin "pkg-config")" || true
    if [ -n "${pc}" ]; then
        out="$("${pc}" --modversion PETSc 2>/dev/null || true)"
        if [ -n "${out}" ]; then
            printf '%s\n' "${out}"
            return 0
        fi
    fi
    petsc_header_version
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

test_version() {
    local out token
    out="$(app_version_output 2>&1 || true)"
    if [ -z "${out}" ]; then
        printf 'FAIL: %s produced no version output\n' "${APP_NAME}"
        return 1
    fi
    for token in $(printf '%s\n' "${out}" | tr -c 'A-Za-z0-9._+-' ' '); do
        if version_matches "${token}"; then
            printf 'PASS: %s reports version %s\n' "${APP_NAME}" "${EXPECTED_VERSION}"
            return 0
        fi
    done
    printf 'FAIL: expected %s version %s, got: %s\n' "${APP_NAME}" "${EXPECTED_VERSION}" \
        "$(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-300)"
    return 1
}

main() {
    local failures=0
    prepare_environment
    test_version || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"
