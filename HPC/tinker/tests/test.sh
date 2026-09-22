#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/tinker-test.XXXXXX")"
trap 'rm -rf "${TEST_DIR}"' EXIT

PARAMS_DIR="/opt/tinker/params"
EXAMPLE_DIR="/opt/tinker/example"
ANALYZE="analyze"
XYZEDIT="xyzedit"

extract_energy() {
    local energy
    energy="$(printf '%s\n' "$1" | sed -n \
        's/^[[:space:]]*Total Potential Energy[[:space:]]*:[[:space:]]*\(-\{0,1\}[0-9][0-9]*\.[0-9][0-9]*\).*$/\1/p')"
    printf '%s' "${energy%%$'\n'*}"
}

to_centi() {
    local value="$1" sign=1 int frac
    case "${value}" in
        -*) sign=-1; value="${value#-}" ;;
    esac
    case "${value}" in
        *.*) int="${value%%.*}"; frac="${value#*.}" ;;
        *)   int="${value}"; frac="0" ;;
    esac
    [ -n "${int}" ] || int=0
    frac="${frac}00"
    frac="${frac:0:2}"
    printf '%s' "$(( sign * (10#${int} * 100 + 10#${frac}) ))"
}

abs_diff() {
    local a="$1" b="$2"
    if (( a > b )); then
        printf '%s' "$(( a - b ))"
    else
        printf '%s' "$(( b - a ))"
    fi
}

prepare_inputs() {
    if [ ! -r "${EXAMPLE_DIR}/water.xyz" ]; then
        printf 'FAIL: expected Tinker example missing: %s/water.xyz\n' \
            "${EXAMPLE_DIR}" >&2
        return 1
    fi
    if [ ! -r "${PARAMS_DIR}/water03.prm" ]; then
        printf 'FAIL: expected parameter file missing: %s/water03.prm\n' \
            "${PARAMS_DIR}" >&2
        return 1
    fi
    cp "${EXAMPLE_DIR}/water.xyz" "${TEST_DIR}/water.xyz"
    printf 'parameters %s/water03\n' "${PARAMS_DIR}" > "${TEST_DIR}/water.key"
}

test_binaries_and_version() {
    local output reported expected_series rc=0

    if ! command -v "${ANALYZE}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found in PATH: %s\n' "${ANALYZE}" >&2
        return 1
    fi
    if ! command -v "${XYZEDIT}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found in PATH: %s\n' "${XYZEDIT}" >&2
        return 1
    fi

    output="$("${ANALYZE}" "${TEST_DIR}/water.xyz" E </dev/null 2>&1)" || rc=$?
    if (( rc != 0 )); then
        printf 'FAIL: %s probe exited %s:\n%s\n' "${ANALYZE}" "${rc}" "${output}" >&2
        return 1
    fi

    reported="$(printf '%s\n' "${output}" \
        | sed -n 's/.*Version \([0-9][0-9]*\.[0-9][0-9]*\).*/\1/p')"
    reported="${reported%%$'\n'*}"
    if [[ -z "${reported}" ]]; then
        printf 'FAIL: no Tinker version banner in output:\n%s\n' "${output}" >&2
        return 1
    fi

    if [[ "${reported}" == "${EXPECTED_VERSION}" ]]; then
        printf 'PASS: exact version: %s\n' "${reported}"
        return 0
    fi

    expected_series="${EXPECTED_VERSION%.*}"
    if [[ "${reported}" == "${expected_series}" ]]; then
        printf 'PASS: version series: banner=%s expected=%s\n' \
            "${reported}" "${EXPECTED_VERSION}"
        return 0
    fi

    printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
        "${EXPECTED_VERSION}" "${reported}" >&2
    return 1
}

test_core_function() {
    local out0 out1 out2 e0 e1 e2 c0 c1 c2 delta rc

    rc=0
    out0="$("${ANALYZE}" "${TEST_DIR}/water.xyz" E </dev/null 2>&1)" || rc=$?
    if (( rc != 0 )); then
        printf 'FAIL: %s on example water exited %s:\n%s\n' \
            "${ANALYZE}" "${rc}" "${out0}" >&2
        return 1
    fi
    if [[ "${out0}" != *'Energy Component Breakdown'* ]]; then
        printf 'FAIL: no energy component breakdown produced:\n%s\n' "${out0}" >&2
        return 1
    fi
    e0="$(extract_energy "${out0}")"
    if [[ -z "${e0}" ]]; then
        printf 'FAIL: no total potential energy produced:\n%s\n' "${out0}" >&2
        return 1
    fi

    rc=0
    "${XYZEDIT}" "${TEST_DIR}/water.xyz" 16 </dev/null >/dev/null 2>&1 || rc=$?
    if (( rc != 0 )); then
        printf 'FAIL: %s center-of-mass translation exited %s\n' \
            "${XYZEDIT}" "${rc}" >&2
        return 1
    fi
    if [[ ! -s "${TEST_DIR}/water.xyz_2" ]]; then
        printf 'FAIL: %s did not write a translated structure\n' "${XYZEDIT}" >&2
        return 1
    fi

    rc=0
    out1="$("${ANALYZE}" "${TEST_DIR}/water.xyz_2" E </dev/null 2>&1)" || rc=$?
    if (( rc != 0 )); then
        printf 'FAIL: %s on translated water exited %s:\n%s\n' \
            "${ANALYZE}" "${rc}" "${out1}" >&2
        return 1
    fi
    e1="$(extract_energy "${out1}")"
    if [[ -z "${e1}" ]]; then
        printf 'FAIL: no energy for translated structure:\n%s\n' "${out1}" >&2
        return 1
    fi

    c0="$(to_centi "${e0}")"
    c1="$(to_centi "${e1}")"
    delta="$(abs_diff "${c0}" "${c1}")"
    if (( delta > 2 )); then
        printf 'FAIL: energy changed under rigid translation: %s vs %s\n' \
            "${e0}" "${e1}" >&2
        return 1
    fi
    printf 'PASS: energy invariant under rigid translation (%s vs %s)\n' \
        "${e0}" "${e1}"

    cat > "${TEST_DIR}/stretch.xyz" <<'EOF'
     3  Stretched water
     1  O      0.000000    0.000000    0.000000     1     2     3
     2  H     -1.135425    0.878823    0.000000     2     1
     3  H      1.135425    0.878823    0.000000     2     1
EOF
    printf 'parameters %s/water03\n' "${PARAMS_DIR}" > "${TEST_DIR}/stretch.key"

    rc=0
    out2="$("${ANALYZE}" "${TEST_DIR}/stretch.xyz" E </dev/null 2>&1)" || rc=$?
    if (( rc != 0 )); then
        printf 'FAIL: %s on stretched water exited %s:\n%s\n' \
            "${ANALYZE}" "${rc}" "${out2}" >&2
        return 1
    fi
    e2="$(extract_energy "${out2}")"
    if [[ -z "${e2}" ]]; then
        printf 'FAIL: no energy for stretched structure:\n%s\n' "${out2}" >&2
        return 1
    fi

    c2="$(to_centi "${e2}")"
    delta="$(abs_diff "${c0}" "${c2}")"
    if (( delta < 1 )); then
        printf 'FAIL: energy did not respond to stretched geometry: %s vs %s\n' \
            "${e0}" "${e2}" >&2
        return 1
    fi
    printf 'PASS: energy responds to geometry (water=%s stretched=%s)\n' \
        "${e0}" "${e2}"
}

main() {
    local failures=0

    if ! prepare_inputs; then
        failures=$((failures + 1))
    fi
    if ! test_binaries_and_version; then
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
