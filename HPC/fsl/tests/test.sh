#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

APP_NAME="fsl"

find_fsldir() {
    local d
    if [[ -n "${FSLDIR:-}" && -d "${FSLDIR}" ]]; then
        printf '%s\n' "${FSLDIR}"
        return 0
    fi
    for d in /usr/local/fsl /opt/fsl; do
        if [[ -d "${d}" ]]; then
            printf '%s\n' "${d}"
            return 0
        fi
    done
    return 1
}

setup_fsl() {
    if ! FSLDIR="$(find_fsldir)"; then
        printf 'FAIL: could not locate FSLDIR\n' >&2
        return 1
    fi
    export FSLDIR

    if [[ -f "${FSLDIR}/etc/fslconf/fsl.sh" ]]; then
        set +eu
        # shellcheck disable=SC1090
        . "${FSLDIR}/etc/fslconf/fsl.sh"
        set -eu
    fi
    return 0
}

test_version() {
    local fv v

    fv="${FSLDIR}/etc/fslversion"
    if [[ ! -f "${fv}" ]]; then
        printf 'FAIL: %s not found\n' "${fv}" >&2
        return 1
    fi

    v="$(<"${fv}")"
    if [[ "${v}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${v}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${v}"
}

test_fslmaths_data_path() {
    local std work out rc seven zero
    local nz nz0 mean d1 d2 d3 total

    std="${FSLDIR}/data/standard/MNI152_T1_2mm.nii.gz"
    if [[ ! -f "${std}" ]]; then
        printf 'FAIL: standard template missing: %s\n' "${std}" >&2
        return 1
    fi

    work="$(mktemp -d)"
    trap "rm -rf '${work}'" RETURN

    # Build a constant-valued image (every voxel == 7) from the MNI152
    # template. This exercises read -> voxelwise arithmetic -> NIfTI write.
    if ! out="$(fslmaths "${std}" -mul 0 -add 7 "${work}/seven" 2>&1)"; then
        rc=$?
        printf 'FAIL: fslmaths constant-image write exited %s: %s\n' \
            "${rc}" "${out}" >&2
        return 1
    fi

    # Read the written image back: the count of non-zero voxels must equal
    # the total number of voxels (the "-add 7" made every voxel non-zero,
    # including the zero-valued background of the source template).
    if ! out="$(fslstats "${work}/seven" -V 2>&1)"; then
        rc=$?
        printf 'FAIL: fslstats -V exited %s: %s\n' "${rc}" "${out}" >&2
        return 1
    fi
    read -r nz _ <<< "${out}"

    if ! out="$(fslval "${work}/seven" dim1 2>&1)"; then
        rc=$?
        printf 'FAIL: fslval dim1 exited %s: %s\n' "${rc}" "${out}" >&2
        return 1
    fi
    read -r d1 <<< "${out}"

    if ! out="$(fslval "${work}/seven" dim2 2>&1)"; then
        rc=$?
        printf 'FAIL: fslval dim2 exited %s: %s\n' "${rc}" "${out}" >&2
        return 1
    fi
    read -r d2 <<< "${out}"

    if ! out="$(fslval "${work}/seven" dim3 2>&1)"; then
        rc=$?
        printf 'FAIL: fslval dim3 exited %s: %s\n' "${rc}" "${out}" >&2
        return 1
    fi
    read -r d3 <<< "${out}"

    total=$(( d1 * d2 * d3 ))
    if [[ "${nz}" != "${total}" ]]; then
        printf 'FAIL: non-zero voxel count mismatch: expected=<%s> actual=<%s>\n' \
            "${total}" "${nz}" >&2
        return 1
    fi

    # The mean of the constant image must be exactly 7.
    if ! out="$(fslstats "${work}/seven" -m 2>&1)"; then
        rc=$?
        printf 'FAIL: fslstats -m exited %s: %s\n' "${rc}" "${out}" >&2
        return 1
    fi
    read -r mean <<< "${out}"
    if [[ "${mean}" != "7.000000" ]]; then
        printf 'FAIL: constant-image mean mismatch: expected=<7.000000> actual=<%s>\n' \
            "${mean}" >&2
        return 1
    fi

    # Multiply by zero: the result must contain no non-zero voxels.
    if ! out="$(fslmaths "${std}" -mul 0 "${work}/zero" 2>&1)"; then
        rc=$?
        printf 'FAIL: fslmaths zero-image write exited %s: %s\n' \
            "${rc}" "${out}" >&2
        return 1
    fi

    if ! out="$(fslstats "${work}/zero" -V 2>&1)"; then
        rc=$?
        printf 'FAIL: fslstats -V (zero image) exited %s: %s\n' \
            "${rc}" "${out}" >&2
        return 1
    fi
    read -r nz0 _ <<< "${out}"
    if [[ "${nz0}" != "0" ]]; then
        printf 'FAIL: zero-image non-zero voxel count: expected=<0> actual=<%s>\n' \
            "${nz0}" >&2
        return 1
    fi

    printf 'PASS: fslmaths write/read data path\n'
}

main() {
    local failures=0

    if ! setup_fsl; then
        failures=$((failures + 1))
    fi

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_fslmaths_data_path; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
