#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# WPS 4.7.0 ships geogrid.exe / ungrib.exe / metgrid.exe in /WPS and the
# auxiliary programs in /WPS/util (see the WPS "compile" script, which links
# the utilities only inside util/).  All WPS programs are batch tools: they
# consume WPS intermediate-format files, not network services.
WPS_DIR="/WPS"
MOD_LEVS_EXE="${WPS_DIR}/util/mod_levs.exe"
RD_INTERMEDIATE_EXE="${WPS_DIR}/util/rd_intermediate.exe"

workdir=""
cleanup() {
    if [[ -n "${workdir}" ]]; then
        rm -rf "${workdir}"
    fi
}
trap cleanup EXIT

# Emit one WPS intermediate-format (format version 5) field to stdout.
#
# Layout taken from util/src/write_met_module.F / util/src/read_met_module.F
# and util/src/met_data_module.F of the pinned WPS v4.7.0 sources:
#   record 1 : integer  version
#   record 2 : hdate(24) xfcst(4) map_source(32) field(9) units(25)
#              desc(46) xlvl(4) nx(4) ny(4) iproj(4)          = 156 bytes
#   record 3 : startloc(8) startlat startlon deltalat deltalon
#              earth_radius (lat-lon projection)              = 28 bytes
#   record 4 : logical  is_wind_grid_rel
#   record 5 : real     slab(nx,ny)
#
# WPS is compiled with gfortran flags -fconvert=big-endian
# -frecord-marker=4 (arch/configure.defaults), so every value, every string
# and every 4-byte sequential record marker is big-endian.
emit_field() {
    local field_name="$1"
    local level_hex="$2"
    local slab_hex="$3"

    # record 1: format version = 5
    printf '\x00\x00\x00\x04\x00\x00\x00\x05\x00\x00\x00\x04'

    # record 2: header, 24+4+32+9+25+46+4+4+4+4 = 156 bytes
    printf '\x00\x00\x00\x9c'
    printf '%-24s' '2019-09-04_12:00:00'   # hdate
    printf '\x00\x00\x00\x00'               # xfcst = 0.0
    printf '%-32s' 'GFS'                    # map_source
    printf '%-9s' "${field_name}"           # field
    printf '%-25s' 'K'                      # units
    printf '%-46s' 'Temperature'            # desc
    printf '%b' "${level_hex}"              # xlvl
    printf '\x00\x00\x00\x02'               # nx = 2
    printf '\x00\x00\x00\x02'               # ny = 2
    printf '\x00\x00\x00\x00'               # iproj = 0 (cylindrical equidistant)
    printf '\x00\x00\x00\x9c'

    # record 3: lat-lon projection, 8 + 5*4 = 28 bytes
    printf '\x00\x00\x00\x1c'
    printf '%-8s' 'SWCORNER'                # startloc
    printf '\x00\x00\x00\x00'               # startlat = 0.0
    printf '\x00\x00\x00\x00'               # startlon = 0.0
    printf '\x3f\x80\x00\x00'               # deltalat = 1.0
    printf '\x3f\x80\x00\x00'               # deltalon = 1.0
    printf '\x45\xc7\x18\x00'               # earth_radius = 6371.0
    printf '\x00\x00\x00\x1c'

    # record 4: is_wind_grid_rel = .true.
    printf '\x00\x00\x00\x04\x00\x00\x00\x01\x00\x00\x00\x04'

    # record 5: slab, 2*2 reals
    printf '\x00\x00\x00\x10'
    printf '%b' "${slab_hex}"
    printf '\x00\x00\x00\x10'
}

test_version() {
    local geo_bin met_bin geo_src met_src geo_title met_title

    if ! command -v grep >/dev/null 2>&1; then
        printf 'FAIL: grep is required to inspect the shipped WPS sources\n' >&2
        return 1
    fi

    geo_bin="${WPS_DIR}/geogrid.exe"
    met_bin="${WPS_DIR}/metgrid.exe"
    geo_src="${WPS_DIR}/geogrid/src/process_tile_module.F"
    met_src="${WPS_DIR}/metgrid/src/process_domain_module.F"

    if [[ ! -x "${geo_bin}" ]]; then
        printf 'FAIL: WPS executable not found or not executable: %s\n' \
            "${geo_bin}" >&2
        return 1
    fi
    if [[ ! -x "${met_bin}" ]]; then
        printf 'FAIL: WPS executable not found or not executable: %s\n' \
            "${met_bin}" >&2
        return 1
    fi
    if [[ ! -f "${geo_src}" ]]; then
        printf 'FAIL: WPS source not found: %s\n' "${geo_src}" >&2
        return 1
    fi
    if [[ ! -f "${met_src}" ]]; then
        printf 'FAIL: WPS source not found: %s\n' "${met_src}" >&2
        return 1
    fi

    geo_title="OUTPUT FROM GEOGRID V${EXPECTED_VERSION}"
    met_title="OUTPUT FROM METGRID V${EXPECTED_VERSION}"

    # WPS exposes no --version switch.  The release string is compiled verbatim
    # into the output-file title of each program ('OUTPUT FROM GEOGRID V4.7.0'
    # in geogrid/src/process_tile_module.F and 'OUTPUT FROM METGRID V4.7.0' in
    # metgrid/src/process_domain_module.F).  A fixed-string match on the shipped
    # *executables* is not portable: with -O gfortran folds the metgrid title
    # assignment into machine immediates in the text section, so on x86_64 the
    # byte sequence is no longer contiguous inside metgrid.exe (on aarch64 it
    # stays in .rodata and matches).  Check the exact literal in the sources that
    # produced those binaries instead; it pins the exact release and rejects any
    # other release deterministically on both architectures.
    if ! grep -Fq -- "'${geo_title}'" "${geo_src}"; then
        printf 'FAIL: %s does not carry the expected release tag <%s>\n' \
            "${geo_src}" "${geo_title}" >&2
        return 1
    fi
    if ! grep -Fq -- "'${met_title}'" "${met_src}"; then
        printf 'FAIL: %s does not carry the expected release tag <%s>\n' \
            "${met_src}" "${met_title}" >&2
        return 1
    fi

    printf 'PASS: exact release tags shipped by WPS %s: %s, %s\n' \
        "${EXPECTED_VERSION}" "${geo_title}" "${met_title}"
}

require_contains() {
    local haystack="$1"
    local needle="$2"
    local label="$3"

    if [[ "${haystack}" != *"${needle}"* ]]; then
        printf 'FAIL: %s: expected <%s> in output, got:\n%s\n' \
            "${label}" "${needle}" "${haystack}" >&2
        return 1
    fi
}

test_intermediate_data_path() {
    local input_name output_name
    local rc output readback
    local field_lines line

    if [[ ! -x "${MOD_LEVS_EXE}" ]]; then
        printf 'FAIL: WPS utility not found or not executable: %s\n' \
            "${MOD_LEVS_EXE}" >&2
        return 1
    fi
    if [[ ! -x "${RD_INTERMEDIATE_EXE}" ]]; then
        printf 'FAIL: WPS utility not found or not executable: %s\n' \
            "${RD_INTERMEDIATE_EXE}" >&2
        return 1
    fi

    workdir="$(mktemp -d "${TMPDIR:-/tmp}/wps-test.XXXXXX")"

    # mod_levs reads the &mod_levs group from namelist.wps and keeps only the
    # requested pressure levels (util/src/mod_levs.F).
    printf '%s\n' \
        '&mod_levs' \
        ' press_pa = 100000.0' \
        '/' > "${workdir}/namelist.wps"

    input_name='FILE:2019-09-04_12'
    output_name='new_FILE:2019-09-04_12'

    # Two levels: TT at 100000 Pa must be kept, UU at 85000 Pa must be dropped.
    {
        emit_field 'TT' '\x47\xc3\x50\x00' \
            '\x3f\x80\x00\x00\x40\x00\x00\x00\x40\x40\x00\x00\x40\x80\x00\x00'
        emit_field 'UU' '\x47\xa6\x04\x00' \
            '\x40\x80\x00\x00\x40\x00\x00\x00\x3f\x80\x00\x00\x00\x00\x00\x00'
    } > "${workdir}/${input_name}"

    # Write path: mod_levs reads the intermediate file, filters levels and
    # writes a new intermediate file.
    if output="$(cd "${workdir}" && "${MOD_LEVS_EXE}" "${input_name}" \
            "${output_name}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: mod_levs.exe exited %s:\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if ! require_contains "${output}" 'Processed TT at level 100000.000000' \
            'mod_levs kept the 100000 Pa level'; then
        return 1
    fi
    if ! require_contains "${output}" 'Deleting level 85000.000000' \
            'mod_levs dropped the 85000 Pa level'; then
        return 1
    fi
    if [[ ! -s "${workdir}/${output_name}" ]]; then
        printf 'FAIL: mod_levs.exe produced no output file: %s\n' \
            "${workdir}/${output_name}" >&2
        return 1
    fi

    # Read path: read the file mod_levs wrote back with rd_intermediate.exe and
    # verify the surviving field, grid size and data value.
    if readback="$(cd "${workdir}" && "${RD_INTERMEDIATE_EXE}" \
            "${output_name}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: rd_intermediate.exe exited %s:\n%s\n' "${rc}" \
            "${readback}" >&2
        return 1
    fi

    if ! require_contains "${readback}" 'FIELD = TT' \
            'readback of the kept field'; then
        return 1
    fi
    if ! require_contains "${readback}" 'I,J DIMS = 2, 2' \
            'readback grid dimensions'; then
        return 1
    fi
    if ! require_contains "${readback}" 'DATA(1,1)=1.000000' \
            'readback of the written data value'; then
        return 1
    fi
    if [[ "${readback}" == *'FIELD = UU'* ]]; then
        printf 'FAIL: dropped 85000 Pa field UU is still present in %s\n' \
            "${output_name}" >&2
        return 1
    fi

    field_lines=0
    while IFS= read -r line; do
        case "${line}" in
            'FIELD = '*) field_lines=$((field_lines + 1)) ;;
        esac
    done <<< "${readback}"

    if [[ "${field_lines}" -ne 1 ]]; then
        printf 'FAIL: expected exactly 1 field after filtering, found %s:\n%s\n' \
            "${field_lines}" "${readback}" >&2
        return 1
    fi

    printf 'PASS: mod_levs.exe write + rd_intermediate.exe read of the filtered field\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_intermediate_data_path; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
