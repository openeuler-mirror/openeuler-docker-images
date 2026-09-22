#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# ESPResSo is launched through the `pypresso` wrapper installed in
# /opt/espresso/bin (the Dockerfile sets PATH=/opt/espresso/bin:$PATH).
LAUNCHER="pypresso"

TEST_TMPDIR="$(mktemp -d "${TMPDIR:-/tmp}/espressomd-test.XXXXXX")"
trap 'rm -rf "${TEST_TMPDIR}"' EXIT

test_version() {
    local output rc

    if ! command -v "${LAUNCHER}" >/dev/null 2>&1; then
        printf 'FAIL: %s launcher not found in runtime image PATH\n' \
            "${LAUNCHER}" >&2
        return 1
    fi

    if output="$("${LAUNCHER}" -c \
        'import espressomd; print(espressomd.__version__)' \
        2>"${TEST_TMPDIR}/version.err")"; then
        :
    else
        rc=$?
        printf 'FAIL: version query exited %s\n' "${rc}" >&2
        cat "${TEST_TMPDIR}/version.err" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${output}"
}

test_core_simulation() {
    local output rc
    local script="${TEST_TMPDIR}/simulation.py"

    cat > "${script}" <<'PY'
import espressomd

r0 = 1.2
system = espressomd.System(box_l=[12.0, 12.0, 12.0])
system.time_step = 0.0001
system.cell_system.skin = 0.4

system.non_bonded_inter[0, 0].lennard_jones.set_params(
    epsilon=1.0, sigma=1.0, cutoff=2.5, shift=0.0)

system.part.add(pos=[0.0, 0.0, 0.0])
system.part.add(pos=[r0, 0.0, 0.0])

expected = 4.0 * (r0 ** -12 - r0 ** -6)
non_bonded = float(system.analysis.energy()["non_bonded"])
if abs(non_bonded - expected) > 1e-9:
    raise SystemExit(
        "LJ energy mismatch: expected=%.12f actual=%.12f"
        % (expected, non_bonded))
print("PASS: LJ non-bonded energy %.12f" % non_bonded)

system.integrator.set_vv()
energy_start = float(system.analysis.energy()["total"])
kinetic_start = float(system.analysis.energy()["kinetic"])
system.integrator.run(2000)
energy_end = float(system.analysis.energy()["total"])
kinetic_end = float(system.analysis.energy()["kinetic"])

if abs(kinetic_start) > 1e-12:
    raise SystemExit(
        "unexpected initial kinetic energy: %.12f" % kinetic_start)
if not kinetic_end > 0.0:
    raise SystemExit(
        "integrator did not move particles: final kinetic=%.12f" % kinetic_end)
if abs(energy_end - energy_start) > 1e-5:
    raise SystemExit(
        "energy not conserved: start=%.12f end=%.12f"
        % (energy_start, energy_end))
print(
    "PASS: MD energy conserved %.12f -> %.12f, kinetic %.12f -> %.12f"
    % (energy_start, energy_end, kinetic_start, kinetic_end))
print("SIMULATION_OK")
PY

    if output="$("${LAUNCHER}" "${script}" 2>"${TEST_TMPDIR}/simulation.err")"; then
        :
    else
        rc=$?
        printf 'FAIL: simulation exited %s\n' "${rc}" >&2
        printf '%s\n' "${output}" >&2
        cat "${TEST_TMPDIR}/simulation.err" >&2
        return 1
    fi

    if [[ "${output}" != *"SIMULATION_OK"* ]]; then
        printf 'FAIL: simulation did not report completion: %s\n' \
            "${output}" >&2
        return 1
    fi

    printf 'PASS: core simulation\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_core_simulation; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
