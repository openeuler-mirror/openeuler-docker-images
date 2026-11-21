#!/bin/bash
# KunpengTest functional test for pwdft (plane-wave DFT engine).
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version dir name), DOCKER_NAMESPACE, DOCKER_PACKAGE,
# DOCKER_TAG, DOCKER_IMAGE.
#
# The image is versioned by the upstream PWDFT git commit: the version
# directories under HPC/pwdft are short commit hashes (e.g. 8259536), see
# meta.yml / image-info.yml. The Dockerfile runs
#   git clone https://github.com/ebylaska/PWDFT.git pwdft
# into /opt/pwdft and never removes .git, so the checked-out commit is the
# authoritative in-image version identifier.
#
# PWDFT is a CLI batch program. Its upstream project version is fixed at 1.0
# (Nwpw/CMakeLists.txt: project(PWDFT VERSION 1.0)); `pwdft --version` prints
# "pwdft (NWChemEx) - Version 1.0" and does not change between snapshot images,
# so the version assertion compares the source commit against EXPECTED_VERSION.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

PWDFT_BIN="/usr/local/bin/pwdft"
SOURCE_DIR="/opt/pwdft"

WORKDIR=""
cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

# Minimal single-point PSPW energy input, reduced from the upstream demo
# DEMO/eric.nw (three C atoms; only `task pspw energy` is kept).
write_input() {
    cat > "$1" <<'EOF'
memory 900 mb
start eric

geometry noautosym noautoz
C 0 0 0
C 0 0 1
C 0 0 2
end

nwpw
   simulation_cell
     SC 20.0
   end
   cutoff 35.00
end
task pspw energy
EOF
}

test_version() {
    local head short out reported

    if [ ! -x "${PWDFT_BIN}" ]; then
        printf 'FAIL: pwdft binary missing or not executable at %s\n' "${PWDFT_BIN}"
        return 1
    fi

    if [ -d "${SOURCE_DIR}/.git" ]; then
        head="$(git -C "${SOURCE_DIR}" rev-parse HEAD 2>/dev/null || true)"
    fi
    if [ -n "${head}" ]; then
        short="${head:0:${#EXPECTED_VERSION}}"
        if [ "${head}" = "${EXPECTED_VERSION}" ] || [ "${short}" = "${EXPECTED_VERSION}" ]; then
            printf 'PASS: source commit matches image version %s\n' "${EXPECTED_VERSION}"
            return 0
        fi
    fi

    out="$("${PWDFT_BIN}" --version 2>&1 || true)"
    reported="$(printf '%s\n' "${out}" | sed -n 's/.*Version \([0-9][0-9.]*\).*/\1/p' | head -n 1)"
    if [ -n "${reported}" ] && [ "${reported}" = "${EXPECTED_VERSION}" ]; then
        printf 'PASS: pwdft --version reports %s\n' "${EXPECTED_VERSION}"
        return 0
    fi

    printf 'FAIL: version mismatch: expected=<%s> commit=<%s> reported=<%s>\n' \
        "${EXPECTED_VERSION}" "${head:-<none>}" "${reported:-<none>}"
    return 1
}

test_core_function() {
    local workdir outfile errfile pid rc out i

    workdir="$(mktemp -d "${TMPDIR:-/tmp}/pwdft-test.XXXXXX")"
    WORKDIR="${workdir}"

    write_input "${workdir}/run.nw"

    outfile="${workdir}/run.out"
    errfile="${workdir}/run.err"

    (
        cd "${workdir}" || exit 1
        export OMPI_ALLOW_RUN_AS_ROOT="${OMPI_ALLOW_RUN_AS_ROOT:-1}"
        export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM="${OMPI_ALLOW_RUN_AS_ROOT_CONFIRM:-1}"
        "${PWDFT_BIN}" run.nw >"${outfile}" 2>"${errfile}"
    ) &
    pid=$!

    rc=""
    i=0
    while [ "${i}" -lt 240 ]; do
        if ! kill -0 "${pid}" 2>/dev/null; then
            wait "${pid}"
            rc=$?
            break
        fi
        i=$((i + 1))
        sleep 0.5
    done

    if [ -z "${rc}" ]; then
        kill "${pid}" 2>/dev/null
        wait "${pid}" 2>/dev/null
        printf 'FAIL: pwdft single-point calculation did not finish within 120s\n'
        return 1
    fi

    if [ "${rc}" -ne 0 ]; then
        printf 'FAIL: pwdft run.nw exited %s\n' "${rc}"
        tail -n 25 "${errfile}" >&2 2>/dev/null
        return 1
    fi

    out="$(cat "${outfile}" 2>/dev/null)"

    if [ -z "${out}" ] || [ "${out}" = "${out#*PWDFT PSPW Calculation}" ]; then
        printf 'FAIL: PSPW calculation banner not found in pwdft output\n'
        return 1
    fi

    if [ "${out}" = "${out#*>>> job completed at}" ]; then
        printf 'FAIL: pwdft did not report a completed job\n'
        return 1
    fi

    printf 'PASS: pwdft completed a PSPW single-point energy calculation\n'
}

main() {
    local failures=0

    test_version       || failures=$((failures + 1))
    test_core_function || failures=$((failures + 1))

    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi

    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"
