#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/moose-test.XXXXXX")"
trap 'rm -rf "${WORKDIR}"' EXIT

MOOSE_BIN="/usr/bin/moose_test-opt"
VERSION_FILE="/usr/share/moose_test/VERSION"

test_version() {
    local reported

    if [[ ! -x "${MOOSE_BIN}" ]]; then
        printf 'FAIL: moose_test-opt not found at %s\n' "${MOOSE_BIN}" >&2
        return 1
    fi

    if [[ ! -f "${VERSION_FILE}" ]]; then
        printf 'FAIL: version file not found: %s\n' "${VERSION_FILE}" >&2
        return 1
    fi

    reported="$(< "${VERSION_FILE}")"
    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${reported}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${reported}"
}

test_diffusion() {
    local input="${WORKDIR}/diffusion.i"
    local output rc

    cat > "${input}" <<'EOF'
[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 5
[]

[Variables]
  [u]
  []
[]

[Kernels]
  [diff]
    type = Diffusion
    variable = u
  []
[]

[BCs]
  [left]
    type = DirichletBC
    variable = u
    boundary = left
    value = 0
  []
  [right]
    type = DirichletBC
    variable = u
    boundary = right
    value = 1
  []
[]

[Executioner]
  type = Steady
[]

[Outputs]
  console = true
  exodus = false
[]
EOF

    if ! output="$("${MOOSE_BIN}" -i "${input}" --n-threads=1 2>&1)"; then
        rc=$?
        printf 'FAIL: moose_test-opt exited with status %s\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if ! grep -q "Solve Converged!" <<< "${output}"; then
        printf 'FAIL: expected "Solve Converged!" in moose output:\n%s\n' "${output}" >&2
        return 1
    fi

    printf 'PASS: steady diffusion example converged\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_diffusion; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
