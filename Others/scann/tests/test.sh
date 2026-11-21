#!/bin/bash
# KunpengTest functional test for scann.
#
# scann is a Python approximate-nearest-neighbour search library, installed into
# the image with `pip install scann==<VERSION>` under /opt/python39 (Dockerfile:
# ENV PATH=/opt/python39/bin:$PATH). It has no CLI, server or version macro, so
# the image is exercised by importing the package, asserting its installed
# version via importlib.metadata, and running a deterministic brute-force
# nearest-neighbour search round-trip through the pybind bindings.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

PYTHON_BIN="/opt/python39/bin/python3"
WORKDIR=""

cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

resolve_python() {
    if [ -x "${PYTHON_BIN}" ]; then
        printf '%s\n' "${PYTHON_BIN}"
        return 0
    fi
    if command -v python3 >/dev/null 2>&1; then
        command -v python3
        return 0
    fi
    return 1
}

# Map an image version directory name to the scann PyPI release it installs.
# Every current Dockerfile pins `scann==1.4.2`: the "1.4.2" tag reports that
# exact version, while the google-research commit-hash tags all resolve to the
# same PyPI release. Unknown versions are rejected rather than guessed.
expected_scann_release() {
    case "$1" in
        1.4.2)
            printf '%s\n' "$1"
            ;;
        03ac4dc|07eaa25|3ef5211|5b381db|6e6b1ff|a1e7371|cf993d2|d36068b|e49bbfe|7117df5)
            printf '%s\n' "1.4.2"
            ;;
        *)
            return 1
            ;;
    esac
}

test_version() {
    local python expected actual
    if ! python="$(resolve_python)"; then
        printf 'FAIL: python3 runtime not found\n'
        return 1
    fi
    if ! expected="$(expected_scann_release "${EXPECTED_VERSION}")"; then
        printf 'FAIL: no verified scann release for image version <%s>\n' "${EXPECTED_VERSION}"
        return 1
    fi
    actual="$("${python}" -c 'from importlib.metadata import version; print(version("scann"))' 2>&1 || true)"
    if [ "${actual}" != "${expected}" ]; then
        printf 'FAIL: scann version mismatch: expected=<%s> actual=<%s>\n' "${expected}" "${actual}"
        return 1
    fi
    printf 'PASS: exact scann version %s\n' "${actual}"
}

test_core_function() {
    local python src out
    if ! python="$(resolve_python)"; then
        printf 'FAIL: python3 runtime not found\n'
        return 1
    fi
    WORKDIR="$(mktemp -d /tmp/scann_test.XXXXXX)" || {
        printf 'FAIL: could not create temporary working directory\n'
        return 1
    }
    src="${WORKDIR}/scann_probe.py"
    cat > "${src}" <<'PYEOF'
import numpy as np
import scann

n = 64
d = 8
rng = np.random.default_rng(0)
dataset = rng.random((n, d)).astype(np.float32)

searcher = scann.scann_ops_pybind.builder(dataset, 1, "squared_l2").score_brute_force().build()
neighbors, distances = searcher.search_batched(dataset, final_num_neighbors=1)

ok = True
if neighbors.shape != (n, 1):
    ok = False
elif not np.array_equal(neighbors.flatten(), np.arange(n)):
    ok = False
elif not np.allclose(distances.flatten(), np.zeros(n), atol=1e-5):
    ok = False

if ok:
    print("SCANN_CORE_OK")
else:
    print("SCANN_CORE_FAIL neighbors=%s distances=%s" % (
        neighbors.flatten().tolist(), distances.flatten().tolist()))
    raise SystemExit(1)
PYEOF

    out="$("${python}" "${src}" 2>&1 || true)"
    if [ "${out}" = "SCANN_CORE_OK" ]; then
        printf 'PASS: brute-force nearest-neighbour self-match\n'
        return 0
    fi
    printf 'FAIL: scann search probe: %s\n' "$(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-300)"
    return 1
}

main() {
    local failures=0
    test_version || failures=$((failures + 1))
    test_core_function || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"