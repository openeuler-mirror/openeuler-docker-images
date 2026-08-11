#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

BINARY="protoc"
BINARY_PATH="/usr/local/bin/protoc"
INCLUDE_DIR="/usr/local/include"
WORKDIR=""

require_tool() {
    local tool="$1"
    if ! command -v "${tool}" >/dev/null 2>&1; then
        printf 'FAIL: required runtime tool not found: %s\n' "${tool}" >&2
        return 1
    fi
}

test_version() {
    local output reported rc resolved

    if ! command -v "${BINARY}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found: %s\n' "${BINARY}" >&2
        return 1
    fi

    resolved="$(command -v "${BINARY}")"
    if [[ "${resolved}" != "${BINARY_PATH}" ]]; then
        printf 'FAIL: binary resolved to unexpected path: expected=<%s> actual=<%s>\n' \
            "${BINARY_PATH}" "${resolved}" >&2
        return 1
    fi

    if output="$("${BINARY}" --version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: version command exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != libprotoc\ * ]]; then
        printf 'FAIL: unexpected version output: <%s>\n' "${output}" >&2
        return 1
    fi

    reported="${output#libprotoc }"
    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s> (full output: <%s>)\n' \
            "${EXPECTED_VERSION}" "${reported}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${reported}"
}

test_core_function() {
    local log rc

    for tool in grep mktemp cat rm; do
        require_tool "${tool}" || return 1
    done

    WORKDIR="$(mktemp -d)" || return 1
    trap '[[ -n "${WORKDIR}" ]] && rm -rf "${WORKDIR}"' EXIT

    cat > "${WORKDIR}/person.proto" <<'EOF'
syntax = "proto3";

import "google/protobuf/timestamp.proto";

package test;

message Person {
  string name = 1;
  int32 id = 2;
  string email = 3;
  google.protobuf.Timestamp created_at = 4;
}
EOF

    if log="$("${BINARY}" --cpp_out="${WORKDIR}" -I "${WORKDIR}" -I "${INCLUDE_DIR}" "${WORKDIR}/person.proto" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: protoc --cpp_out failed (exit %s): %s\n' "${rc}" "${log}" >&2
        return 1
    fi

    if [[ ! -f "${WORKDIR}/person.pb.h" || ! -f "${WORKDIR}/person.pb.cc" ]]; then
        printf 'FAIL: expected generated files person.pb.h / person.pb.cc not found in %s\n' "${WORKDIR}" >&2
        return 1
    fi

    if ! grep -qE 'class[[:space:]]+[A-Za-z_][A-Za-z0-9_]*[[:space:]]+Person final' "${WORKDIR}/person.pb.h"; then
        printf 'FAIL: person.pb.h does not define the generated test.Person message class\n' >&2
        return 1
    fi

    if ! grep -q 'created_at' "${WORKDIR}/person.pb.h"; then
        printf 'FAIL: person.pb.h does not expose the accessor for the created_at field\n' >&2
        return 1
    fi

    if ! grep -q 'descriptor_table_google_2fprotobuf_2ftimestamp_2eproto' "${WORKDIR}/person.pb.cc"; then
        printf 'FAIL: person.pb.cc does not reference the imported well-known type descriptor google/protobuf/timestamp.proto\n' >&2
        return 1
    fi

    printf 'PASS: schema parsed, well-known imports resolved from %s, C++ code generated\n' "${INCLUDE_DIR}"
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
