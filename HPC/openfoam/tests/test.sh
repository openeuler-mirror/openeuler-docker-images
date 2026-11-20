#!/bin/bash
# KunpengTest functional test for OpenFOAM.
#
# The CI runs this script inside the image under test with a bash entrypoint,
# the script directory mounted read-only at /tmp/eptest, and the working
# directory set to /tmp/eptest.  EXPECTED_VERSION is injected and holds the
# image version directory name.
#
# The image ENTRYPOINT normally sources etc/bashrc and drops into a shell, but
# the CI overrides the entrypoint, so this script must locate the OpenFOAM
# installation, source its bashrc itself, and exercise a real mesh/solve
# pipeline (blockMesh + icoFoam on the incompressible cavity tutorial).

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

WORKDIR=""
FOAM_DIR=""

cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

# OpenFOAM ships etc/bashrc at the root of the install tree.  The image
# installs it under /opt/OpenFOAM-v<VERSION> (foundation release) or
# /opt/OpenFOAM-dev (development snapshot); discover whichever is present.
find_openfoam_dir() {
    local d
    for d in /opt/OpenFOAM-v* /opt/OpenFOAM-dev /opt/OpenFOAM-*; do
        [ -d "${d}" ] || continue
        [ -f "${d}/etc/bashrc" ] || continue
        printf '%s\n' "${d}"
        return 0
    done
    return 1
}

# Source etc/bashrc once so PATH/LD_LIBRARY_PATH and WM_PROJECT_VERSION are
# available to every test case.
setup_environment() {
    FOAM_DIR="$(find_openfoam_dir)" || return 1
    # shellcheck disable=SC1090
    . "${FOAM_DIR}/etc/bashrc" || return 1
    return 0
}

# OpenFOAM reports its version via WM_PROJECT_VERSION with a leading "v" on
# foundation releases (e.g. "v2606").  Strip that prefix before the exact
# comparison against EXPECTED_VERSION.
normalize_version() {
    local v="$1"
    v="${v#v}"
    v="${v#V}"
    printf '%s\n' "${v}"
}

test_version() {
    local reported norm_reported norm_expected
    reported="${WM_PROJECT_VERSION:-}"
    if [ -z "${reported}" ]; then
        printf 'FAIL: WM_PROJECT_VERSION not set after sourcing etc/bashrc\n'
        return 1
    fi
    norm_reported="$(normalize_version "${reported}")"
    norm_expected="$(normalize_version "${EXPECTED_VERSION}")"
    if [ "${norm_reported}" = "${norm_expected}" ]; then
        printf 'PASS: OpenFOAM reports version %s (expected %s)\n' \
            "${reported}" "${EXPECTED_VERSION}"
        return 0
    fi
    printf 'FAIL: expected OpenFOAM version %s but it reports %s\n' \
        "${EXPECTED_VERSION}" "${reported}"
    return 1
}

# Run the incompressible lid-driven cavity tutorial: blockMesh generates the
# mesh (constant/polyMesh) and icoFoam time-steps the transient flow to the
# configured endTime.  A completed icoFoam run writes a terminating "End" line,
# which is the success marker asserted below.
test_cavity_case() {
    local case_src case_dir log_mesh log_run rc
    case_src="${FOAM_DIR}/tutorials/incompressible/icoFoam/cavity/cavity"
    if [ ! -d "${case_src}" ]; then
        printf 'FAIL: cavity tutorial not found at %s\n' "${case_src}"
        return 1
    fi

    WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/openfoam-test.XXXXXX")" || {
        printf 'FAIL: cannot create temp directory\n'
        return 1
    }
    case_dir="${WORKDIR}/cavity"
    log_mesh="${WORKDIR}/log.blockMesh"
    log_run="${WORKDIR}/log.icoFoam"

    if ! cp -r "${case_src}" "${case_dir}"; then
        printf 'FAIL: cannot copy cavity tutorial into temp directory\n'
        return 1
    fi

    ( cd "${case_dir}" && blockMesh >"${log_mesh}" 2>&1 )
    rc=$?
    if [ "${rc}" -ne 0 ]; then
        printf 'FAIL: blockMesh exited %s (mesh generation)\n' "${rc}"
        return 1
    fi
    if [ ! -f "${case_dir}/constant/polyMesh/points" ]; then
        printf 'FAIL: blockMesh did not produce constant/polyMesh/points\n'
        return 1
    fi

    ( cd "${case_dir}" && icoFoam >"${log_run}" 2>&1 )
    rc=$?
    if [ "${rc}" -ne 0 ]; then
        printf 'FAIL: icoFoam exited %s (cavity solve)\n' "${rc}"
        return 1
    fi
    if ! grep -q '^End[[:space:]]*$' "${log_run}"; then
        printf 'FAIL: icoFoam did not finish (no terminating End line)\n'
        return 1
    fi

    printf 'PASS: cavity tutorial (blockMesh + icoFoam) ran to completion\n'
    return 0
}

main() {
    local failures=0

    if ! setup_environment; then
        printf 'FATAL: cannot locate and source the OpenFOAM environment\n'
        return 1
    fi

    test_version || failures=$((failures + 1))
    test_cavity_case || failures=$((failures + 1))

    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"