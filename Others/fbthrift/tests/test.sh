#!/bin/bash
: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# KunpengTest functional test for fbthrift.
#
# CI runs this file inside the image under test with --entrypoint bash and the
# script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION, DOCKER_NAMESPACE, DOCKER_PACKAGE, DOCKER_TAG, DOCKER_IMAGE.
#
# fbthrift's thrift1 compiler has no --version flag, so the packaged version is
# read from the exact git tag the image was built from (/build, per Dockerfile
# `git clone -b v<VERSION> --depth 1`). The core test compiles a small .thrift
# IDL to C++ (cpp2) and verifies the generated files.

APP_NAME="fbthrift"
SOURCE_DIR="/build"

WORKDIR=""

cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

find_thrift1() {
    command -v thrift1 2>/dev/null
}

test_version() {
    local reported v
    v=""
    if [ -d "${SOURCE_DIR}/.git" ]; then
        v="$(git -C "${SOURCE_DIR}" describe --tags --exact-match HEAD 2>/dev/null || true)"
        if [ -z "${v}" ]; then
            v="$(git -C "${SOURCE_DIR}" describe --tags 2>/dev/null || true)"
        fi
    fi
    reported="${v#v}"
    if [ -n "${reported}" ] && [ "${reported}" = "${EXPECTED_VERSION}" ]; then
        printf 'PASS: %s version %s\n' "${APP_NAME}" "${EXPECTED_VERSION}"
        return 0
    fi
    printf 'FAIL: expected %s version %s, got <%s>\n' \
        "${APP_NAME}" "${EXPECTED_VERSION}" "${reported}"
    return 1
}

test_compile() {
    local thrift1_bin out rc

    thrift1_bin="$(find_thrift1)"
    if [ -z "${thrift1_bin}" ]; then
        printf 'FAIL: thrift1 compiler not found in PATH\n'
        return 1
    fi

    WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/fbthrift-test.XXXXXX")"
    if [ -z "${WORKDIR}" ] || [ ! -d "${WORKDIR}" ]; then
        printf 'FAIL: cannot create working directory\n'
        return 1
    fi

    cat > "${WORKDIR}/Person.thrift" <<'EOF'
package "test.dev/person"

namespace cpp2 test.person

struct Person {
  1: string name;
  2: i32 id;
}
EOF

    out="$("${thrift1_bin}" -o "${WORKDIR}" --gen mstch_cpp2 "${WORKDIR}/Person.thrift" 2>&1)"
    rc=$?
    if [ "${rc}" -ne 0 ]; then
        printf 'FAIL: thrift1 --gen mstch_cpp2 exited %s: %s\n' \
            "${rc}" "$(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-300)"
        return 1
    fi

    if [ ! -f "${WORKDIR}/gen-cpp2/Person_types.h" ] || \
       [ ! -f "${WORKDIR}/gen-cpp2/Person_types.cpp" ]; then
        printf 'FAIL: gen-cpp2/Person_types.h and Person_types.cpp were not generated\n'
        return 1
    fi

    if ! grep -q 'class Person' "${WORKDIR}/gen-cpp2/Person_types.h"; then
        printf 'FAIL: generated Person_types.h does not define the Person struct\n'
        return 1
    fi

    printf 'PASS: thrift1 compiled Person.thrift to gen-cpp2 C++ code\n'
    return 0
}

main() {
    local failures=0

    test_version || failures=$((failures + 1))
    test_compile || failures=$((failures + 1))

    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"
