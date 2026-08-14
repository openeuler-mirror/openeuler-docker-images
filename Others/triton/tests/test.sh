#!/bin/bash
set -euo pipefail

# Functional tests for the openeuler/triton image (triton 3.7.1, Python venv).
# Triton is a Python library: the image's documented primary usage is
# `python3 -c "import triton; print('Triton', triton.__version__)"`.
# Tests run inside the runtime image against the /opt/venv installation.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

PYTHON_BIN="${PYTHON_BIN:-python3}"

cleanup() {
    rm -f /tmp/triton_core_$$.py
}
trap cleanup EXIT

test_version() {
    local output rc

    if ! command -v "${PYTHON_BIN}" >/dev/null 2>&1; then
        printf 'FAIL: python interpreter not found: %s\n' "${PYTHON_BIN}" >&2
        return 1
    fi

    if output="$("${PYTHON_BIN}" -c 'import triton; print(triton.__version__)' 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: version command exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${output}"
}

test_core_function() {
    local output rc

    cat > /tmp/triton_core_$$.py <<'PY'
import triton
import triton.language as tl

# Host-side Triton language utilities (no GPU required): ceiling division.
assert triton.cdiv(7, 4) == 2, triton.cdiv(7, 4)

# Host-side Triton language utilities (no GPU required): next power of two.
assert triton.next_power_of_2(17) == 32, triton.next_power_of_2(17)

# constexpr wrapper semantics.
assert tl.constexpr(3).value == 3, tl.constexpr(3)

# dtype introspection: primitive bitwidth.
assert tl.int32.primitive_bitwidth == 32, tl.int32.primitive_bitwidth
# dtype introspection: floating-point kind.
assert tl.float32.is_floating(), tl.float32.is_floating()

# Real compiler frontend: a @triton.jit kernel must be accepted and its
# cache key (AST-based kernel fingerprint) computed without any GPU.
@triton.jit
def add_kernel(x_ptr, y_ptr, out_ptr, N: tl.constexpr):
    offs = tl.arange(0, N)
    x = tl.load(x_ptr + offs)
    y = tl.load(y_ptr + offs)
    tl.store(out_ptr + offs, x + y)

key = add_kernel.cache_key
assert isinstance(key, str) and len(key) == 64, key

print("TRITON_CORE_OK")
PY

    if output="$("${PYTHON_BIN}" /tmp/triton_core_$$.py 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: core function exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "TRITON_CORE_OK" ]]; then
        printf 'FAIL: core function unexpected output: %s\n' "${output}" >&2
        return 1
    fi

    printf 'PASS: core function (language API + JIT frontend)\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_core_function; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
