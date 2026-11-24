#!/bin/bash
# KunpengTest functional test for grib_api (ECMWF GRIB edition 1/2 codec).
#
# The image installs the grib_api command-line tools into /usr/local/bin and
# ships no sample GRIB data (the Dockerfile removes /tmp/grib_api after
# `make install`). To exercise the real decode path, this test embeds a small,
# standards-compliant GRIB2 message (an ECMWF 2-metre temperature field on a
# 16x31 regular lat/lon grid, 496 values) and decodes it with grib_get.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

WORKDIR=""
cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/grib-api-test.XXXXXX")"

write_sample_grib2() {
    base64 -d > "${WORKDIR}/sample.grib2" <<'GRIB_B64'
R1JJQv//AAIAAAAAAAAEpAAAABUBAGIAAAUAAQfYAgYMAAAAAAAAABECAAEAAQACBAEwMDAxAAAA
SAMAAAAB8AAAAAAG////////////////////AAAAEAAAAB8AAAAA/////wOThwAAAAAAMAAAAAAB
ycOAAB6EgAAehIAAAAAAIgQAAAAAAAAA/4IAAAABAAAAAGcAAAAAAv///////wAAABUFAAAB8AAA
Q4c7wIAKAAAQAAAAAAYG/wAAA+UHIiIl+iBCEssAAA7mD70O8BLVGZAV9RHYETEUvhArDiEkrSbm
JnEkWiLzIRog2hjZGS8bfBv4GNkXphQ3D+kNWycRJ/woKCiqJ8AnZyVPJxYhbR6DHPEYURwsFeQS
+BAWJ7MoqynEKb0nDio9K2IrjS23IwkfLBlrHuQY5hHVEqMsYyzlKhkqlStzKf0wFDSDMsEuxCVt
HZMcWBkOGKIVbDMhMJorKyTXL80uTCH4LjsvcCftKookNiw5H9wWqRhfOhQ5hTgkM0AgpyirMoMu
1DE7K3UlqyvuJOEsdhoFGJ5BeDYWODIr7A53H8wrKyQ7Kigz+zMuMNYzVx97G1seXUNjMHxHrD2X
NeQ8XzYfPAI9+DU2M/sp3yCJHwcdBB/iQo1DyEIKQgpCsUHIPyEyn0I2QXA53zidHpwmRSDuHc5M
qEi2R4RLikjIRLpHm0UEM09GNDyZL3w1ZzgNLnUlrktfTflNuk2JTN9IhkXdOZJF3UQAQ78vZzzW
RhRCsDiZTWhIyUhNRDVGbE04SexImEdASVtHVkPuRnZHd0tSSjlFiUTnUyxURVfRUrtKVE0FSy9K
GUehR8dD9Uu3SM1MbVH2VMBa8VyAWG5QqEGxRwFK7UjXS+5VtVKtSzBMi07dV7ddTVpcXQNZylSj
S3VGsUrLS+5VIFR6UnpRTFzrVyRng2MNXe1d6lscVkZPxU0PTf1OHFItVbNP/FHAVKNfLmAMa2lu
Clw1UypTok4eTqpNJE5BT15O0lEkTXJX41bYZ65qa2nDWOVQyU+zSVFSKUjVS2ZH80lVUcxEyFYr
ZzpyAHcLbCRciFiRXGdcdV+RTUhSD0qBTdpSolYiXYJoPYBQeYBoU2umZXpaJmbAa7ZlTG/nVJtW
P1tSYEFjynaWg9Z6HHpFeLZ90GKnZb1fknDnbQ5mBmlTYARqIW8/fHOTRYq1g6eAK3b7aNxwBnAo
c3FvwHRFfvhlmW5Md0uD/Y7oj8KQnoWSfrl/BHySgl19r39giIuHmopygmCFuYmEl0GZepcfjX5+
7YWwhbyLwYsDjg6XvpjVkp6S/ZX4ko6X7oatmw2d7Yz0ix6UiY7clQyc4J0om/OXB5hroMqgRJGR
jK+RxJKMl6ybF4w6hpOTsJpfnnGdNJiDnmKih6HNjqh2HXdhkieVk351kSyN/o3XkPeS6pa4kmiZ
HZl1mQ57SXzjfdN94Xzci5h8r3uqir+KaYoMisGNlZJwidKGtHmgecp80H9lgBB9WYAyeLZ53XwO
gEF82YTehwZsXmTkdpx5gXutfHl8vITGgHt3CH9bgA19k364eRxyTnX+eak3Nzc3
GRIB_B64
}

# `grib_ls -V` prints: a blank line, "grib_api Version <X.Y.Z>", two blank
# lines (tools/grib_options.c grib_process_runtime_options). Pull the trailing
# token off that line and compare it exactly to the injected expectation.
test_version() {
    local out line ver
    out="$(grib_ls -V 2>&1 || true)"
    ver=""
    while IFS= read -r line; do
        case "${line}" in
            "grib_api Version "*)
                ver="${line#grib_api Version }"
                break
                ;;
        esac
    done <<< "${out}"
    if [ -n "${ver}" ] && [ "${ver}" = "${EXPECTED_VERSION}" ]; then
        echo "PASS: grib_ls -V reports exact version ${ver}"
        return 0
    fi
    echo "FAIL: expected grib_api version ${EXPECTED_VERSION}, got '${ver}'"
    return 1
}

# Decode the embedded GRIB2 message and check a real data path: the parameter
# concept (shortName=2t), the grid (gridType=regular_ll) and the data section
# size (numberOfValues=496).
test_decode_grib2() {
    local out
    if ! write_sample_grib2; then
        echo "FAIL: could not materialise sample GRIB2 message"
        return 1
    fi
    out="$(grib_get -p shortName,gridType,numberOfValues "${WORKDIR}/sample.grib2" 2>&1 || true)"
    out="$(printf '%s' "${out}" | tr -s '[:space:]' ' ' | sed -e 's/^ //' -e 's/ $//')"
    if [ "${out}" = "2t regular_ll 496" ]; then
        echo "PASS: grib_get decoded sample GRIB2 (shortName=2t gridType=regular_ll numberOfValues=496)"
        return 0
    fi
    echo "FAIL: unexpected grib_get output: '${out}'"
    return 1
}

main() {
    local failures=0
    test_version      || failures=$((failures + 1))
    test_decode_grib2 || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        return 0
    fi
    echo "TESTS_FAILED: ${failures} failure(s)"
    return 1
}

main "$@"
