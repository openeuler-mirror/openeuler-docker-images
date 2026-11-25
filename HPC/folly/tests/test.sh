#!/bin/bash
# KunpengTest functional test for folly (Facebook open-source C++ library).
#
# The image installs the folly headers and the static library libfolly.a under
# /usr/local (Dockerfile: -DCMAKE_INSTALL_PREFIX=/usr/local). folly ships no
# CLI that reports a version, so the version is read from the installed
# pkg-config metadata libfolly.pc (its "Version:" field). The functional case
# compiles, links and runs a tiny probe against the installed headers and
# libfolly.a, exercising the folly::dynamic <-> folly::json serialize/parse
# round trip, which requires the compiled library (not just the headers).

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

CXX="${CXX:-g++}"
PREFIX="/usr/local"

PC_FILE=""
LIB_DIR=""
for d in "${PREFIX}/lib" "${PREFIX}/lib64"; do
    if [ -f "${d}/pkgconfig/libfolly.pc" ]; then
        PC_FILE="${d}/pkgconfig/libfolly.pc"
        LIB_DIR="${d}"
        break
    fi
done

WORKDIR=""
cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_version() {
    local actual
    if [ -z "${PC_FILE}" ]; then
        printf 'FAIL: folly pkg-config metadata libfolly.pc not found under %s/lib[64]/pkgconfig\n' "${PREFIX}"
        return 1
    fi
    actual="$(sed -n 's/^Version:[[:space:]]*//p' "${PC_FILE}")"
    actual="$(printf '%s' "${actual}" | tr -d '[:space:]')"
    if [ -z "${actual}" ]; then
        printf 'FAIL: could not parse Version from %s\n' "${PC_FILE}"
        return 1
    fi
    if [ "${actual}" = "${EXPECTED_VERSION}" ]; then
        printf 'PASS: exact folly version %s\n' "${actual}"
        return 0
    fi
    printf "FAIL: expected folly version '%s', got '%s'\n" "${EXPECTED_VERSION}" "${actual}"
    return 1
}

test_core_function() {
    local src bin cflags libs compile_out run_out rc
    src="${WORKDIR}/folly_probe.cpp"
    bin="${WORKDIR}/folly_probe"

    if ! command -v "${CXX}" >/dev/null 2>&1; then
        printf "FAIL: compiler '%s' not found in PATH\n" "${CXX}"
        return 1
    fi
    if ! command -v pkg-config >/dev/null 2>&1; then
        printf 'FAIL: pkg-config not found in PATH\n'
        return 1
    fi
    if [ -z "${LIB_DIR}" ]; then
        printf 'FAIL: folly library directory not found under %s\n' "${PREFIX}"
        return 1
    fi

    cat > "${src}" <<'EOF'
#include <folly/dynamic.h>
#include <folly/json.h>
#include <iostream>
#include <string>

int main() {
    folly::dynamic obj = folly::dynamic::object
        ("name", "folly-probe")
        ("answer", 42);
    std::string out = folly::toJson(obj);
    folly::dynamic back = folly::parseJson(out);
    if (!back.isObject() || back["name"].asString() != "folly-probe" ||
        back["answer"].asInt() != 42) {
        std::cerr << "round-trip mismatch: " << out << std::endl;
        return 1;
    }
    std::cout << "FOLLY_JSON_OK" << std::endl;
    return 0;
}
EOF

    export PKG_CONFIG_PATH="${LIB_DIR}/pkgconfig:${PKG_CONFIG_PATH:-}"

    if ! cflags="$(pkg-config --cflags libfolly 2>&1)"; then
        printf 'FAIL: pkg-config --cflags libfolly failed: %s\n' "$(printf '%s' "${cflags}" | tr '\n' ' ' | cut -c1-200)"
        return 1
    fi
    if ! libs="$(pkg-config --static --libs libfolly 2>&1)"; then
        printf 'FAIL: pkg-config --static --libs libfolly failed: %s\n' "$(printf '%s' "${libs}" | tr '\n' ' ' | cut -c1-200)"
        return 1
    fi
    # folly's libfolly.pc lists only path-based deps in Libs.private; its
    # CMake-target deps (fmt, glog, gflags, pthread) are omitted, so append
    # them for static linking (matching the README canonical link line).
    libs="${libs} -lfmt -lglog -lgflags -lpthread"

    if ! compile_out="$( "${CXX}" -std=c++20 ${cflags} "${src}" -o "${bin}" ${libs} 2>&1 )"; then
        printf 'FAIL: compile/link of folly probe failed: %s\n' "$(printf '%s' "${compile_out}" | tr '\n' ' ' | cut -c1-300)"
        return 1
    fi

    if ! run_out="$("${bin}" 2>&1)"; then
        rc=$?
        printf 'FAIL: folly probe exited %s: %s\n' "${rc}" "$(printf '%s' "${run_out}" | tr '\n' ' ' | cut -c1-300)"
        return 1
    fi

    if [ "${run_out}" = "FOLLY_JSON_OK" ]; then
        printf 'PASS: folly::toJson <-> folly::parseJson round trip\n'
        return 0
    fi
    printf 'FAIL: unexpected folly probe output: %s\n' "$(printf '%s' "${run_out}" | tr '\n' ' ' | cut -c1-300)"
    return 1
}

main() {
    local failures=0
    WORKDIR="$(mktemp -d)"
    if [ ! -d "${WORKDIR}" ]; then
        printf 'FATAL: cannot create temporary working directory\n'
        return 1
    fi
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
