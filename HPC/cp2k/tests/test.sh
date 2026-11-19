#!/bin/bash
# KunpengTest functional test for cp2k (version only).
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version dir name), DOCKER_NAMESPACE, DOCKER_PACKAGE,
# DOCKER_TAG, DOCKER_IMAGE.
#
# The cp2k image normally starts through /usr/local/bin/entrypoint.sh, which
# sources /opt/cp2k/tools/toolchain/install/setup and exports PATH plus
# LD_LIBRARY_PATH for the toolchain shared libraries.  The CI overrides the
# entrypoint with `bash`, so this script has to recreate that environment;
# otherwise cp2k.psmp cannot resolve libraries such as libmclf.so.3.0.0.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

APP_NAME="cp2k"
CP2K_INSTALL_BIN="/opt/cp2k/install/bin"
CP2K_EXE_DIR="/opt/cp2k/exe/local"
CP2K_TOOLCHAIN_INSTALL="/opt/cp2k/tools/toolchain/install"

prepare_environment() {
    local setup_file="${CP2K_TOOLCHAIN_INSTALL}/setup"
    local dir
    if [ -r "${setup_file}" ]; then
        # shellcheck disable=SC1090
        . "${setup_file}" >/dev/null 2>&1 || true
        # A sourced setup script must not leave errexit behind in the test.
        set +e
    fi
    PATH="${CP2K_INSTALL_BIN}:${CP2K_EXE_DIR}:${PATH}"
    export PATH
    for dir in "${CP2K_TOOLCHAIN_INSTALL}"/*/lib \
               "${CP2K_TOOLCHAIN_INSTALL}"/*/lib64 \
               "${CP2K_TOOLCHAIN_INSTALL}/lib" \
               "${CP2K_TOOLCHAIN_INSTALL}/lib64"; do
        [ -d "${dir}" ] || continue
        case ":${LD_LIBRARY_PATH:-}:" in
            *":${dir}:"*) ;;
            *) LD_LIBRARY_PATH="${dir}${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" ;;
        esac
    done
    export LD_LIBRARY_PATH
}

find_bin() {
    local name="$1" p
    for p in "${CP2K_INSTALL_BIN}/${name}" "${CP2K_EXE_DIR}/${name}" \
             "/usr/local/bin/${name}" "/usr/bin/${name}" "/bin/${name}" \
             "/usr/local/sbin/${name}" "/usr/sbin/${name}" "/sbin/${name}"; do
        if [ -x "${p}" ]; then
            printf '%s\n' "${p}"
            return 0
        fi
    done
    command -v "${name}" 2>/dev/null && return 0
    return 1
}

app_version_output() {
    local b
    b="$(find_bin "cp2k")" || true
    [ -n "${b}" ] || return 1
    "${b}" --version 2>&1 || true
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
