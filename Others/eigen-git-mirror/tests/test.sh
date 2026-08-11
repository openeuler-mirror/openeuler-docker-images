#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

INCLUDE_DIR="/usr/local/include/eigen3"
VERSION_SRC=""
CORE_SRC=""
TMPDIR_EIGEN=""

cleanup() {
    if [ -n "${TMPDIR_EIGEN}" ] && [ -d "${TMPDIR_EIGEN}" ]; then
        rm -rf "${TMPDIR_EIGEN}"
    fi
}
trap cleanup EXIT

test_install_layout() {
    if [ ! -d "${INCLUDE_DIR}" ]; then
        printf 'FAIL: Eigen include directory not found: %s\n' "${INCLUDE_DIR}" >&2
        return 1
    fi
    if [ ! -f "${INCLUDE_DIR}/Eigen/Dense" ]; then
        printf 'FAIL: umbrella header not found: %s/Eigen/Dense\n' "${INCLUDE_DIR}" >&2
        return 1
    fi
    if [ ! -d "/usr/local/share/eigen3" ]; then
        printf 'FAIL: Eigen share directory not found: /usr/local/share/eigen3\n' >&2
        return 1
    fi
    printf 'PASS: Eigen headers installed under %s\n' "${INCLUDE_DIR}"
}

test_version() {
    local output rc

    if ! command -v g++ >/dev/null 2>&1; then
        printf 'FAIL: g++ not found (required to compile Eigen test program)\n' >&2
        return 1
    fi

    VERSION_SRC="${TMPDIR_EIGEN}/version_check.cpp"
    cat > "${VERSION_SRC}" <<'EOF'
#include <iostream>
#include <Eigen/Dense>
int main() {
    std::cout << EIGEN_WORLD_VERSION << "." << EIGEN_MAJOR_VERSION << "." << EIGEN_MINOR_VERSION << std::endl;
    return 0;
}
EOF

    if ! output=$(g++ -std=c++11 -I"${INCLUDE_DIR}" -o "${TMPDIR_EIGEN}/version_check" "${VERSION_SRC}" 2>&1); then
        rc=$?
        printf 'FAIL: version program compile failed (exit %s): %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if ! output=$("${TMPDIR_EIGEN}/version_check" 2>&1); then
        rc=$?
        printf 'FAIL: version program exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact Eigen version: %s\n' "${output}"
}

test_core_function() {
    local output rc expected="7 10 15 22"

    CORE_SRC="${TMPDIR_EIGEN}/core_check.cpp"
    cat > "${CORE_SRC}" <<'EOF'
#include <iostream>
#include <Eigen/Dense>
using namespace Eigen;
int main() {
    Matrix<int, 2, 2> a;
    a << 1, 2,
         3, 4;
    Matrix<int, 2, 2> b = a * a;
    std::cout << b(0, 0) << " " << b(0, 1) << " " << b(1, 0) << " " << b(1, 1) << std::endl;
    return 0;
}
EOF

    if ! output=$(g++ -std=c++11 -I"${INCLUDE_DIR}" -o "${TMPDIR_EIGEN}/core_check" "${CORE_SRC}" 2>&1); then
        rc=$?
        printf 'FAIL: core program compile failed (exit %s): %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if ! output=$("${TMPDIR_EIGEN}/core_check" 2>&1); then
        rc=$?
        printf 'FAIL: core program exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: matrix product mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    printf 'PASS: matrix product: %s\n' "${output}"
}

main() {
    local failures=0

    TMPDIR_EIGEN="$(mktemp -d /tmp/eigen_test.XXXXXX)"

    if ! test_install_layout; then
        failures=$((failures + 1))
    fi
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
