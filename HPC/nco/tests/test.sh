#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

test_version() {
    local output line version="" rc=0

    if ! command -v ncks >/dev/null 2>&1; then
        printf 'FAIL: ncks binary not found in image\n' >&2
        return 1
    fi

    if output="$(ncks --version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: ncks --version exited %s:\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi

    while IFS= read -r line; do
        case "${line}" in
            "ncks version "*)
                version="${line#ncks version }"
                break
                ;;
        esac
    done <<< "${output}"

    if [[ -z "${version}" ]]; then
        printf 'FAIL: "ncks version" line not found in output:\n%s\n' "${output}" >&2
        return 1
    fi

    if [[ "${version}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${version}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${version}"
}

test_core_function() {
    local workdir in_cdl in_nc att_nc sq_nc output out_norm val rc=0

    workdir="$(mktemp -d)"
    in_cdl="${workdir}/tst.cdl"
    in_nc="${workdir}/in.nc"
    att_nc="${workdir}/att.nc"
    sq_nc="${workdir}/sq.nc"

    printf '%s\n' \
        'netcdf tst {' \
        'dimensions:' \
        '  time = 4 ;' \
        'variables:' \
        '  double time(time) ;' \
        '  double temp(time) ;' \
        '    temp:units = "K" ;' \
        'data:' \
        '  time = 0., 1., 2., 3. ;' \
        '  temp = 0., 2., 4., 6. ;' \
        '}' > "${in_cdl}"

    if ncgen -o "${in_nc}" "${in_cdl}" 2>"${workdir}/ncgen.err"; then
        :
    else
        rc=$?
        printf 'FAIL: ncgen exited %s: %s\n' "${rc}" "$(cat "${workdir}/ncgen.err")" >&2
        return 1
    fi

    if ncatted -O -a long_name,temp,c,c,Temperature "${in_nc}" "${att_nc}" \
        2>"${workdir}/ncatted.err"; then
        :
    else
        rc=$?
        printf 'FAIL: ncatted exited %s: %s\n' "${rc}" "$(cat "${workdir}/ncatted.err")" >&2
        return 1
    fi

    if output="$(ncks -m "${att_nc}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: ncks -m exited %s:\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi
    if [[ "${output}" != *'temp:long_name = "Temperature"'* ]]; then
        printf 'FAIL: created attribute long_name="Temperature" not found in metadata:\n%s\n' "${output}" >&2
        return 1
    fi
    printf 'PASS: ncatted write + ncks -m readback of attribute\n'

    if ncap2 -s 'temp_sq=temp*temp' -O "${att_nc}" "${sq_nc}" 2>"${workdir}/ncap2.err"; then
        :
    else
        rc=$?
        printf 'FAIL: ncap2 exited %s: %s\n' "${rc}" "$(cat "${workdir}/ncap2.err")" >&2
        return 1
    fi

    if output="$(ncks -H -v temp_sq "${sq_nc}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: ncks -H exited %s:\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi
    out_norm="$(printf '%s' "${output}" | tr -d '[:space:]')"
    for val in 'temp_sq=0,4,16,36;'; do
        if [[ "${out_norm}" != *"${val}"* ]]; then
            printf 'FAIL: computed value <%s> not found in ncks output:\n%s\n' "${val}" "${output}" >&2
            return 1
        fi
    done
    printf 'PASS: ncap2 computed temp_sq=temp*temp and ncks read back all values\n'

    rm -rf "${workdir}"
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
