#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

BINARY="SU2_CFD"

export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
export OMP_NUM_THREADS=1

test_version() {
    local out rc needle

    if ! command -v "${BINARY}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found: %s\n' "${BINARY}" >&2
        return 1
    fi

    out="$("${BINARY}" --help 2>&1)" || {
        rc=$?
        printf 'FAIL: %s --help exited %s: %s\n' "${BINARY}" "${rc}" "${out}" >&2
        return 1
    }

    needle="SU2 v${EXPECTED_VERSION}"
    if [[ "${out}" != *"${needle}"* ]]; then
        printf 'FAIL: version string <%s> not found in %s --help output\n' "${needle}" "${BINARY}" >&2
        return 1
    fi

    printf 'PASS: exact version %s reported by %s --help\n' "${EXPECTED_VERSION}" "${BINARY}"
}

generate_config() {
    cat > "${1}" <<'CFG'
SOLVER= EULER
MATH_PROBLEM= DIRECT
RESTART_SOL= NO
MACH_NUMBER= 0.5
AOA= 0.0
SIDESLIP_ANGLE= 0.0
FREESTREAM_PRESSURE= 101300.0
FREESTREAM_TEMPERATURE= 288.0
REF_LENGTH= 1.0
REF_AREA= 1.0
MARKER_EULER= ( upper_wall, lower_wall )
MARKER_INLET= ( inlet, 288.6, 102010.0, 1.0, 0.0, 0.0 )
MARKER_OUTLET= ( outlet, 101300.0 )
MARKER_MONITORING= ( upper_wall, lower_wall )
NUM_METHOD_GRAD= GREEN_GAUSS
CFL_NUMBER= 1000.0
CFL_ADAPT= NO
ITER= 100
LINEAR_SOLVER= FGMRES
LINEAR_SOLVER_PREC= LU_SGS
LINEAR_SOLVER_ERROR= 1E-1
LINEAR_SOLVER_ITER= 5
MGLEVEL= 0
CONV_NUM_METHOD_FLOW= JST
JST_SENSOR_COEFF= ( 0.5, 0.02 )
TIME_DISCRE_FLOW= EULER_IMPLICIT
MESH_FILENAME= channel.su2
MESH_FORMAT= SU2
TABULAR_FORMAT= CSV
CONV_FILENAME= history
HISTORY_OUTPUT= ( ITER, RMS_RES, AERO_COEFF )
SCREEN_OUTPUT= ( INNER_ITER, RMS_DENSITY )
OUTPUT_FILES= ( RESTART_ASCII )
CFG
}

generate_mesh() {
    python3 - "${1}" <<'PY'
import sys
path = sys.argv[1]
NX, NY = 20, 8
XMIN, XMAX = 0.0, 3.0
YMIN, YMAX = 0.0, 1.0
NPX, NPY = NX + 1, NY + 1
NP = NPX * NPY


def idx(i, j):
    return j * NPX + i


out = []
out.append("NDIME= 2")
out.append("NELEM= %d" % (NX * NY))
e = 0
for j in range(NY):
    for i in range(NX):
        out.append("9 %d %d %d %d %d" % (idx(i, j), idx(i + 1, j), idx(i + 1, j + 1), idx(i, j + 1), e))
        e += 1
out.append("NPOIN= %d" % NP)
p = 0
for j in range(NPY):
    for i in range(NPX):
        x = XMIN + (XMAX - XMIN) * i / NX
        y = YMIN + (YMAX - YMIN) * j / NY
        out.append("%.15g %.15g %d" % (x, y, p))
        p += 1
out.append("NMARK= 4")
out.append("MARKER_TAG= inlet")
out.append("MARKER_ELEMS= %d" % NY)
for j in range(NY):
    out.append("3 %d %d" % (idx(0, j), idx(0, j + 1)))
out.append("MARKER_TAG= outlet")
out.append("MARKER_ELEMS= %d" % NY)
for j in range(NY):
    out.append("3 %d %d" % (idx(NX, j), idx(NX, j + 1)))
out.append("MARKER_TAG= lower_wall")
out.append("MARKER_ELEMS= %d" % NX)
for i in range(NX):
    out.append("3 %d %d" % (idx(i, 0), idx(i + 1, 0)))
out.append("MARKER_TAG= upper_wall")
out.append("MARKER_ELEMS= %d" % NX)
for i in range(NX):
    out.append("3 %d %d" % (idx(i, NY), idx(i + 1, NY)))
with open(path, "w") as f:
    f.write("\n".join(out) + "\n")
PY
}

parse_history() {
    python3 - "${1}" <<'PY'
import sys
import math
path = sys.argv[1]
with open(path) as f:
    lines = f.read().splitlines()


def clean(s):
    return s.replace('"', '').strip()


cd_idx = -1
cl_idx = -1
if lines:
    header = [clean(x) for x in lines[0].split(',')]
    cd_idx = header.index('CD') if 'CD' in header else -1
    cl_idx = header.index('CL') if 'CL' in header else -1

rows = 0
last_cd = None
last_cl = None
if cd_idx >= 0 and cl_idx >= 0:
    for line in lines[1:]:
        cols = line.split(',')
        if len(cols) <= max(cd_idx, cl_idx):
            continue
        try:
            cd = float(cols[cd_idx].strip())
            cl = float(cols[cl_idx].strip())
        except ValueError:
            continue
        if math.isnan(cd) or math.isinf(cd) or math.isnan(cl) or math.isinf(cl):
            continue
        rows += 1
        last_cd = cd
        last_cl = cl

print('header_cd=%d' % (1 if cd_idx >= 0 else 0))
print('header_cl=%d' % (1 if cl_idx >= 0 else 0))
print('rows=%d' % rows)
print('CD=%s' % ('' if last_cd is None else repr(last_cd)))
print('CL=%s' % ('' if last_cl is None else repr(last_cl)))
PY
}

test_solver() {
    local workdir solve_out rc banner hist parsed line key val
    local header_cd=0 header_cl=0 rows="" cd_val="" cl_val=""

    workdir="$(mktemp -d)"
    trap '[[ ${FUNCNAME[0]} == test_solver ]] && rm -rf "${workdir}"' RETURN

    generate_config "${workdir}/inv_channel.cfg"
    generate_mesh "${workdir}/channel.su2"

    export OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 OMP_NUM_THREADS=1

    set +e
    solve_out="$(cd "${workdir}" && "${BINARY}" inv_channel.cfg 2>&1)"
    rc=$?
    set -e

    if (( rc != 0 )); then
        printf 'FAIL: %s exited %s:\n%s\n' "${BINARY}" "${rc}" "${solve_out}" >&2
        return 1
    fi

    banner="Release ${EXPECTED_VERSION}"
    if [[ "${solve_out}" != *"${banner}"* ]]; then
        printf 'FAIL: release banner <%s> not found in solver output\n' "${banner}" >&2
        return 1
    fi

    hist="${workdir}/history.csv"
    if [[ ! -f "${hist}" ]]; then
        printf 'FAIL: convergence history file not produced: %s\n' "${hist}" >&2
        return 1
    fi

    parsed="$(parse_history "${hist}")"
    while IFS='=' read -r key val; do
        case "${key}" in
            header_cd) header_cd="${val}" ;;
            header_cl) header_cl="${val}" ;;
            rows) rows="${val}" ;;
            CD) cd_val="${val}" ;;
            CL) cl_val="${val}" ;;
        esac
    done <<< "${parsed}"

    if [[ "${header_cd}" != "1" || "${header_cl}" != "1" ]]; then
        printf 'FAIL: history file missing CD/CL columns\n' >&2
        return 1
    fi

    if ! [[ "${rows}" =~ ^[0-9]+$ ]] || (( rows < 2 )); then
        printf 'FAIL: expected multiple solver iterations in history, got rows=<%s>\n' "${rows}" >&2
        return 1
    fi

    if [[ "${cd_val}" == "" || "${cl_val}" == "" ]]; then
        printf 'FAIL: could not parse finite CD/CL coefficients from history\n' >&2
        return 1
    fi

    printf 'PASS: %s solved the Euler channel case (%s iterations, CD=%s, CL=%s)\n' \
        "${BINARY}" "${rows}" "${cd_val}" "${cl_val}"
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_solver; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
