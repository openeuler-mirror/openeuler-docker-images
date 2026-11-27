#!/bin/bash

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# Binaries installed by the Dockerfile: cmake --install with
# CMAKE_INSTALL_PREFIX=/usr/local and target SUFFIX ".x"
BINARY="/usr/local/bin/wannier90.x"
POST_BINARY="/usr/local/bin/postw90.x"

# `wannier90.x --version` / `postw90.x --version` print the w90_version label
# declared in src/io.F90, prefixed by "Wannier90: "/"Postw90: ".  For most tags
# that label equals EXPECTED_VERSION (e.g. v4.0.3 declares '4.0.3').  The one
# exception is the v4.0.2 source, which still declares '4.0.1 ' and therefore
# prints "Wannier90: 4.0.1"; the version test admits that legacy label only for
# the 4.0.2 tag.

# The .win driven test model uses these; keep them in sync with the .win below.
NUM_BANDS=2
NUM_WANN=2

WORKDIR=""

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

dump_diagnostics() {
    local f
    for f in "${WORKDIR}/seed.werr" "${WORKDIR}/seed.wout"; do
        if [[ -s "${f}" ]]; then
            printf -- '--- %s ---\n' "${f}" >&2
            sed 's/^/    /' "${f}" >&2
        fi
    done
}

test_binaries() {
    local b
    for b in "${BINARY}" "${POST_BINARY}"; do
        if [[ ! -x "${b}" ]]; then
            printf 'FAIL: expected executable not found: %s\n' "${b}" >&2
            return 1
        fi
    done
    printf 'PASS: binaries present: %s, %s\n' "${BINARY}" "${POST_BINARY}"
}

test_version() {
    local output rc reported

    if output="$("${BINARY}" --version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: wannier90.x --version exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "Wannier90: "* ]]; then
        printf 'FAIL: unexpected wannier90.x --version output: <%s>\n' "${output}" >&2
        return 1
    fi
    reported="${output#Wannier90: }"
    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        if [[ "${EXPECTED_VERSION}" == "4.0.2" && "${reported}" == "4.0.1" ]]; then
            :
        else
            printf 'FAIL: wannier90.x version mismatch: expected=<%s> actual=<%s> (full output: <%s>)\n' \
                "${EXPECTED_VERSION}" "${reported}" "${output}" >&2
            return 1
        fi
    fi

    if output="$("${POST_BINARY}" --version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: postw90.x --version exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi
    if [[ "${output}" != "Postw90: "* ]]; then
        printf 'FAIL: unexpected postw90.x --version output: <%s>\n' "${output}" >&2
        return 1
    fi
    reported="${output#Postw90: }"
    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        if [[ "${EXPECTED_VERSION}" == "4.0.2" && "${reported}" == "4.0.1" ]]; then
            :
        else
            printf 'FAIL: postw90.x version mismatch: expected=<%s> actual=<%s> (full output: <%s>)\n' \
                "${EXPECTED_VERSION}" "${reported}" "${output}" >&2
            return 1
        fi
    fi

    printf 'PASS: exact version label: %s\n' "${EXPECTED_VERSION}"
}

write_win() {
    cat > "${WORKDIR}/seed.win" <<EOF
! wannier90 functional test model
num_bands        = ${NUM_BANDS}
num_wann         = ${NUM_WANN}
use_bloch_phases = true
num_iter         = 5

begin unit_cell_cart
ang
 4.0 0.0 0.0
 0.0 4.0 0.0
 0.0 0.0 4.0
end unit_cell_cart

begin atoms_frac
Si 0.0 0.0 0.0
end atoms_frac

mp_grid = 2 1 1
EOF
}

test_preprocess() {
    local output rc

    if output="$(cd "${WORKDIR}" && "${BINARY}" -pp seed 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: wannier90.x -pp exited %s: %s\n' "${rc}" "${output}" >&2
        dump_diagnostics
        return 1
    fi

    if [[ ! -s "${WORKDIR}/seed.nnkp" ]]; then
        printf 'FAIL: wannier90.x -pp did not produce seed.nnkp\n' >&2
        dump_diagnostics
        return 1
    fi
    if ! grep -q 'begin real_lattice' "${WORKDIR}/seed.nnkp"; then
        printf 'FAIL: seed.nnkp has no real_lattice block\n' >&2
        return 1
    fi
    if ! grep -q 'begin kpoints' "${WORKDIR}/seed.nnkp"; then
        printf 'FAIL: seed.nnkp has no kpoints block\n' >&2
        return 1
    fi
    if ! grep -q 'begin nnkpts' "${WORKDIR}/seed.nnkp"; then
        printf 'FAIL: seed.nnkp has no nnkpts block\n' >&2
        return 1
    fi

    printf 'PASS: -pp generated %s.nnkp (kmesh + nearest-neighbour list)\n' "seed"
}

# Build seed.mmn with unit overlap matrices from the nearest-neighbour list
# that the application itself wrote into seed.nnkp.
write_mmn() {
    local in_nn line nntot npairs nkn nkp nkp2 nnl nnm nnn n m

    in_nn=0
    : > "${WORKDIR}/nnkpts.txt"
    while IFS= read -r line; do
        case "${line}" in
            *"begin nnkpts"*) in_nn=1; continue ;;
            *"end nnkpts"*) in_nn=0; continue ;;
        esac
        if (( in_nn == 1 )); then
            printf '%s\n' "${line}" >> "${WORKDIR}/nnkpts.txt"
        fi
    done < "${WORKDIR}/seed.nnkp"

    nntot="$(head -n 1 "${WORKDIR}/nnkpts.txt")"
    nntot="${nntot// /}"
    if ! [[ "${nntot}" =~ ^[0-9]+$ ]] || (( nntot < 1 )); then
        printf 'FAIL: could not read nntot from seed.nnkp\n' >&2
        return 1
    fi

    tail -n +2 "${WORKDIR}/nnkpts.txt" > "${WORKDIR}/pairs.txt"
    npairs="$(wc -l < "${WORKDIR}/pairs.txt")"
    npairs="${npairs// /}"
    if (( npairs < 1 )) || (( npairs % nntot != 0 )); then
        printf 'FAIL: inconsistent nnkpts list (pairs=%s nntot=%s)\n' "${npairs}" "${nntot}" >&2
        return 1
    fi
    nkn=$(( npairs / nntot ))

    {
        printf 'overlaps for the wannier90 functional test (unit matrices)\n'
        printf '%d %d %d\n' "${NUM_BANDS}" "${nkn}" "${nntot}"
        while read -r nkp nkp2 nnl nnm nnn; do
            if [[ -z "${nkp:-}" ]]; then
                continue
            fi
            printf '%d %d %d %d %d\n' "${nkp}" "${nkp2}" "${nnl}" "${nnm}" "${nnn}"
            for (( n = 1; n <= NUM_BANDS; n++ )); do
                for (( m = 1; m <= NUM_BANDS; m++ )); do
                    if (( m == n )); then
                        printf '1.000000 0.000000\n'
                    else
                        printf '0.000000 0.000000\n'
                    fi
                done
            done
        done < "${WORKDIR}/pairs.txt"
    } > "${WORKDIR}/seed.mmn"

    if [[ ! -s "${WORKDIR}/seed.mmn" ]]; then
        printf 'FAIL: could not generate seed.mmn\n' >&2
        return 1
    fi
}

test_wannierise() {
    local output rc

    if ! write_mmn; then
        return 1
    fi

    if output="$(cd "${WORKDIR}" && "${BINARY}" seed 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: wannier90.x seed exited %s: %s\n' "${rc}" "${output}" >&2
        dump_diagnostics
        return 1
    fi

    if [[ ! -s "${WORKDIR}/seed.wout" ]]; then
        printf 'FAIL: wannier90.x seed produced no seed.wout\n' >&2
        dump_diagnostics
        return 1
    fi
    if ! grep -qF 'All done: wannier90 exiting' "${WORKDIR}/seed.wout"; then
        printf 'FAIL: wannierisation did not reach normal completion (seed.wout)\n' >&2
        dump_diagnostics
        return 1
    fi
    if [[ ! -s "${WORKDIR}/seed.chk" ]]; then
        printf 'FAIL: wannierisation wrote no checkpoint file seed.chk\n' >&2
        dump_diagnostics
        return 1
    fi

    printf 'PASS: full wannierisation completed and wrote checkpoint seed.chk\n'
}

main() {
    local failures=0

    WORKDIR="$(mktemp -d /tmp/wannier90_test.XXXXXX)"
    if [[ ! -d "${WORKDIR}" ]]; then
        printf 'FAIL: cannot create temporary working directory\n' >&2
        return 1
    fi
    write_win

    if ! test_binaries; then
        failures=$((failures + 1))
    fi
    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_preprocess; then
        failures=$((failures + 1))
    fi
    if ! test_wannierise; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
