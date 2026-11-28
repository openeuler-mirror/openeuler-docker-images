#!/bin/bash

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# miniGhost is an MPI halo-exchange mini-app (Mantevo suite). The image builds
# /opt/miniGhost/ref/miniGhost.x and installs OpenMPI whose launchers live in
# /usr/lib64/openmpi/bin (added to PATH in the Dockerfile). The documented
# invocation is `mpirun --allow-run-as-root -np 4 ./miniGhost.x`. The program
# reports its own version (MG_VERSION in ref/MG_CONSTANTS.F) only when the
# performance report is enabled (--report_perf > 0).
#
# miniGhost publishes no release tags; the build pins a fixed git commit whose
# only semantic version is the MG_VERSION constant (1.0.0) in MG_CONSTANTS.F.
# EXPECTED_VERSION is therefore a commit SHA, not the program's semantic
# version, so we derive the expected version from the compiled source instead.

export OMPI_ALLOW_RUN_AS_ROOT="${OMPI_ALLOW_RUN_AS_ROOT:-1}"
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM="${OMPI_ALLOW_RUN_AS_ROOT_CONFIRM:-1}"

MINIGHOST_BIN="/opt/miniGhost/ref/miniGhost.x"
MINIGHOST_CONSTANTS="/opt/miniGhost/ref/MG_CONSTANTS.F"
MPIRUN_BIN="mpirun"

WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/minighost-test.XXXXXX")"
trap 'rm -rf "${WORKDIR}"' EXIT

test_version() {
    local stdout_file="${WORKDIR}/version.stdout"
    local stderr_file="${WORKDIR}/version.stderr"
    local expected_version ver_line ver rc

    expected_version="$(grep -oE 'MG_VERSION[[:space:]]*=[[:space:]]*"[0-9]+\.[0-9]+(\.[0-9]+)?' \
        "${MINIGHOST_CONSTANTS}" | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1)"
    if [ -z "${expected_version}" ]; then
        printf 'FAIL: could not read MG_VERSION from %s\n' "${MINIGHOST_CONSTANTS}" >&2
        return 1
    fi

    # A small 2-rank problem: rank 0 emits the report header containing the
    # "miniGhost version" line (MG_VERSION constant).
    if ( cd "${WORKDIR}" && \
         "${MPIRUN_BIN}" --allow-run-as-root -np 2 "${MINIGHOST_BIN}" \
             --nx 10 --ny 10 --nz 10 --num_vars 2 --num_tsteps 2 \
             --stencil 21 --report_perf 1 \
             >"${stdout_file}" 2>"${stderr_file}" ); then
        :
    else
        rc=$?
        printf 'FAIL: miniGhost version probe exited %s\n' "${rc}" >&2
        return 1
    fi

    ver_line="$(grep -E 'miniGhost version[[:space:]]+[0-9]' "${stdout_file}" | head -n1)"
    if [ -z "${ver_line}" ]; then
        printf 'FAIL: no miniGhost version string in report output\n' >&2
        return 1
    fi

    ver="$(printf '%s\n' "${ver_line}" | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1)"
    if [ -z "${ver}" ]; then
        printf 'FAIL: could not parse version from report output\n' >&2
        return 1
    fi
    if [ "${ver}" != "${expected_version}" ]; then
        printf 'FAIL: version mismatch: expected <%s>, got <%s>\n' \
            "${expected_version}" "${ver}" >&2
        return 1
    fi

    printf 'PASS: exact miniGhost version %s\n' "${ver}"
}

test_mpi_run() {
    local stdout_file="${WORKDIR}/run.stdout"
    local stderr_file="${WORKDIR}/run.stderr"
    local yaml_file="${WORKDIR}/results.yaml"
    local rc

    # Real 4-rank BSPMA halo exchange with a 2D 5-point stencil and a global
    # reduction (percent_sum=100). On success rank 0 writes a machine-readable
    # results.yaml summary, which we assert against.
    if ( cd "${WORKDIR}" && \
         "${MPIRUN_BIN}" --allow-run-as-root -np 4 "${MINIGHOST_BIN}" \
             --nx 40 --ny 40 --nz 40 --num_vars 5 --num_tsteps 20 \
             --stencil 21 --percent_sum 100 \
             >"${stdout_file}" 2>"${stderr_file}" ); then
        :
    else
        rc=$?
        printf 'FAIL: miniGhost 4-rank run exited %s\n' "${rc}" >&2
        return 1
    fi

    if ! grep -q 'Mantevo miniapp MiniGhost experiment' "${stdout_file}"; then
        printf 'FAIL: miniGhost header banner not found on stdout\n' >&2
        return 1
    fi

    if [ ! -s "${yaml_file}" ]; then
        printf 'FAIL: results.yaml not produced by run\n' >&2
        return 1
    fi

    if ! grep -q 'Computation: 5-point difference stencil on a 2D grid (STENCIL_2D5PT)' "${yaml_file}"; then
        printf 'FAIL: expected STENCIL_2D5PT computation in results.yaml\n' >&2
        return 1
    fi

    if ! grep -q 'Comm_strategy: full message aggregation (COMM_METHOD_BSPMA)' "${yaml_file}"; then
        printf 'FAIL: expected COMM_METHOD_BSPMA in results.yaml\n' >&2
        return 1
    fi

    if ! grep -q 'Scaling: weak' "${yaml_file}"; then
        printf 'FAIL: expected weak scaling in results.yaml\n' >&2
        return 1
    fi

    if ! grep -qE 'processes:[[:space:]]+4[[:space:]]*$' "${yaml_file}"; then
        printf 'FAIL: expected 4 MPI processes in results.yaml\n' >&2
        grep -E 'processes:' "${yaml_file}" >&2 || true
        return 1
    fi

    if ! grep -qE 'Time_steps:[[:space:]]+20[[:space:]]*$' "${yaml_file}"; then
        printf 'FAIL: expected 20 time steps in results.yaml\n' >&2
        return 1
    fi

    printf 'PASS: 4-rank MPI halo-exchange run completed (BSPMA + 2D5PT + global sum)\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_mpi_run; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
