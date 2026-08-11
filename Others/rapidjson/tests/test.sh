#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

RAPIDJSON_HEADER="/usr/include/rapidjson/rapidjson.h"
WORKDIR=""

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_headers_installed() {
    if [[ ! -f "${RAPIDJSON_HEADER}" ]]; then
        printf 'FAIL: rapidjson headers not installed at %s\n' "${RAPIDJSON_HEADER}" >&2
        return 1
    fi
    printf 'PASS: headers installed at %s\n' "${RAPIDJSON_HEADER}"
}

test_version() {
    local src="${WORKDIR}/version_probe.cpp"
    local bin="${WORKDIR}/version_probe"
    local output rc

    cat > "${src}" <<'EOF'
#include "rapidjson/rapidjson.h"
#include <iostream>
int main() {
    std::cout << RAPIDJSON_VERSION_STRING << std::endl;
    return 0;
}
EOF

    if ! output="$(g++ -std=c++11 "${src}" -o "${bin}" 2>&1)"; then
        rc=$?
        printf 'FAIL: g++ compile of version probe exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if ! output="$("${bin}" 2>&1)"; then
        rc=$?
        printf 'FAIL: version probe exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${output}"
}

test_dom_roundtrip() {
    local src="${WORKDIR}/simpledom.cpp"
    local bin="${WORKDIR}/simpledom"
    local expected='{"project":"rapidjson","stars":11}'
    local output rc

    cat > "${src}" <<'EOF'
#include "rapidjson/document.h"
#include "rapidjson/writer.h"
#include "rapidjson/stringbuffer.h"
#include <iostream>

using namespace rapidjson;

int main() {
    const char* json = "{\"project\":\"rapidjson\",\"stars\":10}";
    Document d;
    d.Parse(json);

    Value& s = d["stars"];
    s.SetInt(s.GetInt() + 1);

    StringBuffer buffer;
    Writer<StringBuffer> writer(buffer);
    d.Accept(writer);

    std::cout << buffer.GetString() << std::endl;
    return 0;
}
EOF

    if ! output="$(g++ -std=c++11 "${src}" -o "${bin}" 2>&1)"; then
        rc=$?
        printf 'FAIL: g++ compile of simpledom example exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if ! output="$("${bin}" 2>&1)"; then
        rc=$?
        printf 'FAIL: simpledom example exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: simpledom output mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    printf 'PASS: DOM parse/modify/stringify roundtrip: %s\n' "${output}"
}

main() {
    local failures=0

    WORKDIR="$(mktemp -d)"
    if [[ ! -d "${WORKDIR}" ]]; then
        printf 'FAIL: cannot create temp working directory\n' >&2
        return 1
    fi

    if ! test_headers_installed; then
        failures=$((failures + 1))
    fi
    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_dom_roundtrip; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
