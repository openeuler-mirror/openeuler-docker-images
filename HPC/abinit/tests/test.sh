#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# ABINIT is configured with --prefix=/usr/local (binaries and libraries).
# The runtime stage installs openmpi, whose launchers live in
# /usr/lib64/openmpi/bin (and /usr/bin) on this OS.
export PATH="/usr/local/bin:/usr/lib64/openmpi/bin:${PATH}"

ABINIT_BIN="abinit"
MPIRUN_BIN="mpirun"
# ABINIT's own wall-clock bound: `abinit <input> --timelimit H:MM:SS`
# (src/95_drive/m_argparse.F90).  Using the application option keeps the test
# from depending on the external `timeout` tool being present in the image.
TIMELIMIT="0:10:00"

WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/abinit-test.XXXXXX")"
trap 'rm -rf "${WORKDIR}"' EXIT

# openmpi refuses to run as root unless these are set; the Dockerfile also sets
# them, this keeps the test independent of how the container is launched.
export OMPI_ALLOW_RUN_AS_ROOT="${OMPI_ALLOW_RUN_AS_ROOT:-1}"
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM="${OMPI_ALLOW_RUN_AS_ROOT_CONFIRM:-1}"

# 01h.pspgth: the Goedecker-Teter-Hutter H pseudopotential shipped with ABINIT
# as tests/Pspdir/PseudosGTH_pwteter/01h.pspgth. Pseudopotentials are not
# installed by `make install`, so the test writes this tiny text pseudo itself.
write_pseudo_h() {
    local psp="${WORKDIR}/01h.pspgth"

    cat > "${psp}" <<'PSP_EOF'
Goedecker-Teter-Hutter  Wed May  8 14:27:44 EDT 1996
1   1   960508                     zatom,zion,pspdat
2   1   0    0    2001    0.       pspcod,pspxc,lmax,lloc,mmax,r2well
0.2000000 -4.0663326  0.6778322 0 0     rloc, c1, c2, c3, c4
0 0 0                              rs, h1s, h2s
0 0                                rp, h1p
  1.36 .2   0.0                    rcutoff, rloc
PSP_EOF
}

# 83bi.5.hgh: the HGH Bi pseudopotential shipped with ABINIT as
# tests/Pspdir/PseudosHGH_pwteter/83bi.5.hgh, required by built-in test 6.
write_pseudo_bi() {
    local psp="${WORKDIR}/83bi.5.hgh"

    cat > "${psp}" <<'PSP_EOF'
Hartwigsen-Goedecker-Hutter psp for Bi,  from PRB58, 3641 (1998)
   83   5  010605 zatom,zion,pspdat
 3 1   2 0 2001 0  pspcod,pspxc,lmax,lloc,mmax,r2well
  0.605000    6.679437    0.000000    0.000000   0.000000 rloc, c1, c2, c3, c4
  0.678858    1.377634   -0.513697   -0.471028          rs, h11s, h22s, h33s
  0.798673    0.655578   -0.402932    0.000000          rp, h11p, h22p, h33p
              0.305314   -0.023134    0.000000                          k11p, k22p, k33p
  0.934683    0.378476    0.000000    0.000000          rd, h11d, h22d, h33d
              0.029217    0.000000    0.000000                          k11d, k22d, k33d
  0.000000    0.000000    0.000000    0.000000          rf, h11f, h22f, h33f
              0.000000    0.000000    0.000000                          k11f, k22f, k33f
PSP_EOF
}

# H2 molecule input of ABINIT's built-in test "fast" (builtintest 1), taken
# from tests/built-in/Input/testin_fast.abi. Only the pseudopotential location
# is adapted to point at the file written above.
write_h2_input() {
    local input="${WORKDIR}/run.abi"

    cat > "${input}" <<'ABI_EOF'
# Hydrogen diatomic molecule for built-in test 1 (H2, Broyden minimization)
 builtintest 1

 acell 12 10 10
 diemac 1.0d0   diemix 0.5d0
 ecut 4.5

 ionmov  2
 densfor_pred 1

 istatr 99

 kptopt 0
 kpt   3*0.25
 natom  2
 nband 1

 nkpt 1
 nline 3
 nstep 7
 nsym 8
 ntime  5
 ntypat  1
 occ 2
 occopt 0

 prtvol  10

 rprim 1 0 0  0 1 0  0 0 1
 symrel  1  0  0   0  1  0   0  0  1
        -1  0  0   0  1  0   0  0  1
         1  0  0   0 -1  0   0  0  1
        -1  0  0   0 -1  0   0  0  1
         1  0  0   0  1  0   0  0 -1
        -1  0  0   0  1  0   0  0 -1
         1  0  0   0 -1  0   0  0 -1
        -1  0  0   0 -1  0   0  0 -1
 tnons 24*0
 toldff 5.0d-6
 tolmxf 5.0d-5
 typat  2*1
 wtk  1
 xcart  -0.385 0 0   0.385  0 0   Angstrom
 znucl  1.0

 pp_dirpath "."
 pseudos "01h.pspgth"
ABI_EOF
}

# Bi atom with GGA PBE from LibXC: ABINIT's built-in test 6, taken from
# tests/built-in/Input/testin_libxc.abi.  `ixc -101130` encodes LibXC
# functionals 101 (GGA_X_PBE) and 130 (GGA_C_PBE).  Explicit prefixes keep the
# generated file names deterministic.
write_libxc_input() {
    local input="${WORKDIR}/lxc.abi"

    cat > "${input}" <<'ABI_EOF'
# Bi atom : GGA PBE from LibXC
 builtintest 6

#GGA PBE
ixc -101130

#Common data
acell 3*11
diemac 2.0d0
diemix 0.5d0
ecut 10

nband 4 4
kptopt 0
nkpt 1
nstep 2
occopt 2
occ 1 1 1 1  1 0 0 0
tolwfr 1.0d-14
xred 3*0

ntypat 1
natom 1
typat 1
znucl 83

nspinor 1
nsppol  2
nspden  2
spinat  0.0 0.0 1.0

 outdata_prefix "lxco"
 tmpdata_prefix "lxct"

 pp_dirpath "."
 pseudos "83bi.5.hgh"
ABI_EOF
}

# Small H2 SCF on a two-k-point mesh.  With two k-points and -np 2 ABINIT
# distributes the k-points over the two MPI ranks, so this exercises the MPI
# data path the image is built for.  prtwf/prtden are off to keep this run
# focused on the parallel compute path.
write_mpi_input() {
    local input="${WORKDIR}/mpi.abi"

    cat > "${input}" <<'ABI_EOF'
# H2 molecule on a two-k-point mesh: exercises MPI k-point parallelism.
 acell 12 10 10
 diemac 1.0
 ecut 4.5

 ionmov 0
 nstep 25
 tolvrs 1.0d-8

 kptopt 0
 nkpt 2
 kpt  0.0 0.0 0.0
      0.25 0.25 0.25
 wtk  0.5 0.5

 natom 2
 nband 2
 ntypat 1
 occopt 0
 occ 2 0
 nsppol 1

 rprim 1 0 0  0 1 0  0 0 1
 typat 2*1
 xcart -0.385 0 0   0.385 0 0   Angstrom
 znucl 1.0

 prtwf 0
 prtden 0

 outdata_prefix "mpio"
 tmpdata_prefix "mpit"

 pp_dirpath "."
 pseudos "01h.pspgth"
ABI_EOF
}

dump_failure() {
    local label="$1" stdout_file="$2" stderr_file="$3" rc="$4"

    printf 'FAIL: %s exited %s\n' "${label}" "${rc}" >&2
    if [[ -s "${stderr_file}" ]]; then
        printf -- '--- stderr ---\n' >&2
        cat "${stderr_file}" >&2
    fi
    if [[ -s "${stdout_file}" ]]; then
        printf -- '--- stdout (last 40 lines) ---\n' >&2
        tail -n 40 "${stdout_file}" >&2
    fi
}

# Every completed run writes " Calculation completed." to stdout from the
# master process and a YAML "--- !FinalSummary" block reporting the version.
assert_run_output() {
    local label="$1" out="$2"

    if [[ "${out}" != *"Calculation completed."* ]]; then
        printf 'FAIL: %s: "Calculation completed." not found on stdout\n' "${label}" >&2
        return 1
    fi
    if [[ "${out}" != *"--- !FinalSummary"* ]]; then
        printf 'FAIL: %s: "--- !FinalSummary" not found on stdout\n' "${label}" >&2
        return 1
    fi
    if [[ "${out}" != *"version: ${EXPECTED_VERSION}"* ]]; then
        printf 'FAIL: %s: FinalSummary does not report version %s\n' \
            "${label}" "${EXPECTED_VERSION}" >&2
        return 1
    fi
}

# A built-in test writes a status file whose presence/absence is controlled by
# `builtintest`; a passing reference comparison adds "the run finished cleanly".
assert_status_clean() {
    local status_file="$1" label="$2" status

    if [[ ! -f "${status_file}" ]]; then
        printf 'FAIL: %s: built-in status file not found: %s\n' \
            "${label}" "${status_file}" >&2
        return 1
    fi
    status="$(<"${status_file}")"
    if [[ "${status}" != *"==> The run finished cleanly."* ]]; then
        printf 'FAIL: %s: built-in reference check did not pass; %s content:\n%s\n' \
            "${label}" "${status_file}" "${status}" >&2
        return 1
    fi
}

# With HAVE_NETCDF_DEFAULT the I/O mode defaults to IO_MODE_ETSF, so the WFK
# wavefunction is written through the netCDF library as "<prefix>_WFK.nc".
# Validate the container format from the file signature (no `file` needed).
check_netcdf_artifact() {
    local ncf="$1" sig

    if [[ ! -s "${ncf}" ]]; then
        printf 'FAIL: NetCDF artifact missing or empty: %s\n' "${ncf}" >&2
        return 1
    fi
    sig="$(head -c 4 "${ncf}")"
    if [[ "${sig}" == $'\x89HDF' || "${sig}" == $'CDF\x01' || "${sig}" == $'CDF\x02' ]]; then
        printf 'PASS: NetCDF/HDF5 artifact verified: %s\n' "${ncf}"
        return 0
    fi
    printf 'FAIL: %s is not a netCDF/HDF5 file (first 4 bytes: %q)\n' "${ncf}" "${sig}" >&2
    return 1
}

test_version() {
    local out rc

    if ! command -v "${ABINIT_BIN}" >/dev/null 2>&1; then
        printf 'FAIL: %s not found in PATH\n' "${ABINIT_BIN}" >&2
        return 1
    fi

    if out="$("${ABINIT_BIN}" --version 2>"${WORKDIR}/version.err")"; then
        :
    else
        rc=$?
        printf 'FAIL: %s --version exited %s:\n%s\n' \
            "${ABINIT_BIN}" "${rc}" "$(<"${WORKDIR}/version.err")" >&2
        return 1
    fi

    if [[ "${out}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${out}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${out}"
}

test_h2_builtin() {
    local rc stdout_file stderr_file out

    stdout_file="${WORKDIR}/h2.stdout"
    stderr_file="${WORKDIR}/h2.stderr"

    write_pseudo_h
    write_h2_input

    if ( cd "${WORKDIR}" && \
         "${ABINIT_BIN}" run.abi --timelimit "${TIMELIMIT}" \
             >"${stdout_file}" 2>"${stderr_file}" ); then
        :
    else
        rc=$?
        dump_failure "${ABINIT_BIN} run.abi" "${stdout_file}" "${stderr_file}" "${rc}"
        return 1
    fi

    out="$(<"${stdout_file}")"
    if ! assert_run_output "serial H2 built-in" "${out}"; then
        tail -n 40 "${stdout_file}" >&2
        return 1
    fi
    if ! assert_status_clean "${WORKDIR}/runt_STATUS" "serial H2 built-in"; then
        return 1
    fi
    if ! check_netcdf_artifact "${WORKDIR}/runo_WFK.nc"; then
        return 1
    fi

    printf 'PASS: serial H2 built-in run: reference physics check + NetCDF output\n'
}

test_libxc_builtin() {
    local rc stdout_file stderr_file out

    stdout_file="${WORKDIR}/lxc.stdout"
    stderr_file="${WORKDIR}/lxc.stderr"

    write_pseudo_bi
    write_libxc_input

    if ( cd "${WORKDIR}" && \
         "${ABINIT_BIN}" lxc.abi --timelimit "${TIMELIMIT}" \
             >"${stdout_file}" 2>"${stderr_file}" ); then
        :
    else
        rc=$?
        dump_failure "${ABINIT_BIN} lxc.abi (LibXC)" "${stdout_file}" "${stderr_file}" "${rc}"
        return 1
    fi

    out="$(<"${stdout_file}")"
    if ! assert_run_output "LibXC built-in" "${out}"; then
        tail -n 40 "${stdout_file}" >&2
        return 1
    fi
    if ! assert_status_clean "${WORKDIR}/lxct_STATUS" "LibXC built-in"; then
        return 1
    fi

    printf 'PASS: LibXC built-in run: LibXC-linked Bi/PBE SCF + reference physics check\n'
}

test_mpi_parallel() {
    local rc stdout_file stderr_file out

    if ! command -v "${MPIRUN_BIN}" >/dev/null 2>&1; then
        printf 'FAIL: %s not found in PATH\n' "${MPIRUN_BIN}" >&2
        return 1
    fi

    stdout_file="${WORKDIR}/mpi.stdout"
    stderr_file="${WORKDIR}/mpi.stderr"

    write_pseudo_h
    write_mpi_input

    if ( cd "${WORKDIR}" && \
         "${MPIRUN_BIN}" -np 2 "${ABINIT_BIN}" mpi.abi --timelimit "${TIMELIMIT}" \
             >"${stdout_file}" 2>"${stderr_file}" ); then
        :
    else
        rc=$?
        dump_failure "${MPIRUN_BIN} -np 2 ${ABINIT_BIN} mpi.abi" \
            "${stdout_file}" "${stderr_file}" "${rc}"
        return 1
    fi

    out="$(<"${stdout_file}")"
    if ! assert_run_output "2-rank MPI" "${out}"; then
        tail -n 40 "${stdout_file}" >&2
        return 1
    fi

    # ABINIT writes the final per-rank timing line from every process to its own
    # standard output, but for nproc >= NPROC_NO_EXTRA_LOG (2) the non-master
    # ranks have their stdout redirected to /dev/null (iofn1 in
    # src/44_abitypes_defs/m_dtfil.F90).  Hence the merged mpirun stdout only
    # contains the master's timing line.  Verify the MPI rank count the way
    # ABINIT itself reports it in the dataset header instead.
    if ! grep -qE 'mpi_nproc:[[:space:]]*2,' "${stdout_file}"; then
        printf 'FAIL: ABINIT did not report running on 2 MPI processes\n' >&2
        grep -E 'mpi_nproc:' "${stdout_file}" >&2 || true
        tail -n 40 "${stdout_file}" >&2
        return 1
    fi

    printf 'PASS: 2-rank MPI k-point-parallel calculation completed (mpi_nproc: 2)\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_h2_builtin; then
        failures=$((failures + 1))
    fi
    if ! test_libxc_builtin; then
        failures=$((failures + 1))
    fi
    if ! test_mpi_parallel; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
