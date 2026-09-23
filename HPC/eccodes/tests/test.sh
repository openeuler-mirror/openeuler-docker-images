#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT

INFO_BINARY="codes_info"
SET_BINARY="grib_set"
GET_BINARY="grib_get"
SAMPLE_NAME="regular_ll_sfc_grib2.tmpl"
CONSTANT_VALUE="42"
EXPECTED_SHORT_NAME="t"
SAMPLE_PATH=""

require_binary() {
    local bin="$1"
    if ! command -v "${bin}" >/dev/null 2>&1; then
        printf 'FAIL: required binary not found in PATH: %s\n' "${bin}" >&2
        return 1
    fi
}

test_version() {
    local output rc

    if ! require_binary "${INFO_BINARY}"; then
        return 1
    fi

    if output="$("${INFO_BINARY}" -v 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: "%s -v" exited %s: %s\n' "${INFO_BINARY}" "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${output}"
}

resolve_sample() {
    local samples dirs d rc

    if samples="$("${INFO_BINARY}" -s 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: "%s -s" exited %s: %s\n' "${INFO_BINARY}" "${rc}" "${samples}" >&2
        return 1
    fi

    SAMPLE_PATH=""
    IFS=':' read -r -a dirs <<< "${samples}"
    for d in "${dirs[@]}"; do
        if [[ -n "${d}" && -f "${d}/${SAMPLE_NAME}" ]]; then
            SAMPLE_PATH="${d}/${SAMPLE_NAME}"
            break
        fi
    done

    if [[ -z "${SAMPLE_PATH}" ]]; then
        printf 'FAIL: sample %s not found under samples path <%s>\n' \
            "${SAMPLE_NAME}" "${samples}" >&2
        return 1
    fi
}

test_core_function() {
    local output rc encoded key

    if ! require_binary "${SET_BINARY}"; then
        return 1
    fi
    if ! require_binary "${GET_BINARY}"; then
        return 1
    fi

    if ! resolve_sample; then
        return 1
    fi

    encoded="${WORKDIR}/encoded.grib2"

    if output="$("${SET_BINARY}" -s "shortName=${EXPECTED_SHORT_NAME}" \
        -d "${CONSTANT_VALUE}" "${SAMPLE_PATH}" "${encoded}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: "%s -s shortName=%s -d %s" exited %s: %s\n' \
            "${SET_BINARY}" "${EXPECTED_SHORT_NAME}" "${CONSTANT_VALUE}" \
            "${rc}" "${output}" >&2
        return 1
    fi

    if [[ ! -s "${encoded}" ]]; then
        printf 'FAIL: %s did not write a non-empty GRIB file: %s\n' \
            "${SET_BINARY}" "${encoded}" >&2
        return 1
    fi

    if output="$("${GET_BINARY}" -p shortName "${encoded}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: "%s -p shortName" exited %s: %s\n' \
            "${GET_BINARY}" "${rc}" "${output}" >&2
        return 1
    fi
    if [[ "${output}" != "${EXPECTED_SHORT_NAME}" ]]; then
        printf 'FAIL: shortName mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_SHORT_NAME}" "${output}" >&2
        return 1
    fi
    printf 'PASS: encoded metadata read back: shortName=%s\n' "${output}"

    for key in minimum maximum average; do
        if output="$("${GET_BINARY}" -F "%.0f" -p "${key}" "${encoded}" 2>&1)"; then
            :
        else
            rc=$?
            printf 'FAIL: "%s -p %s" exited %s: %s\n' \
                "${GET_BINARY}" "${key}" "${rc}" "${output}" >&2
            return 1
        fi
        if [[ "${output}" != "${CONSTANT_VALUE}" ]]; then
            printf 'FAIL: %s mismatch: expected=<%s> actual=<%s>\n' \
                "${key}" "${CONSTANT_VALUE}" "${output}" >&2
            return 1
        fi
    done
    printf 'PASS: constant data value %s round-trips (minimum/maximum/average)\n' \
        "${CONSTANT_VALUE}"
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
