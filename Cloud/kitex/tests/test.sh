#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

BINARY="kitex"
BINARY_PATH="/usr/local/bin/kitex"

# The Kitex CLI prints the constant compiled into the pinned source
# (kitex.Version in version.go), not the release tag. Upstream did not bump
# that constant after v0.14.1, so tags v0.14.2..v0.14.5 all self-report
# "v0.14.1". Map the requested release to the constant its source declares.
VERSION="${EXPECTED_VERSION#v}"
case "${VERSION}" in
    0.14.2|0.14.3|0.14.4|0.14.5) EXPECTED_REPORTED_VERSION="v0.14.1" ;;
    *) EXPECTED_REPORTED_VERSION="v${VERSION}" ;;
esac

WORKDIR=""

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_version() {
    local output rc resolved

    if ! command -v "${BINARY}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found in PATH: %s\n' "${BINARY}" >&2
        return 1
    fi

    if [[ ! -x "${BINARY_PATH}" ]]; then
        printf 'FAIL: expected binary is not executable: %s\n' "${BINARY_PATH}" >&2
        return 1
    fi

    resolved="$(command -v "${BINARY}")"
    if [[ "${resolved}" != "${BINARY_PATH}" ]]; then
        printf 'FAIL: %s resolved to unexpected path: expected=<%s> actual=<%s>\n' \
            "${BINARY}" "${BINARY_PATH}" "${resolved}" >&2
        return 1
    fi

    if output="$("${BINARY}" --version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: version command exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_REPORTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s> (full output: <%s>)\n' \
            "${EXPECTED_REPORTED_VERSION}" "${output}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${output}"
}

test_code_generation() {
    local output rc generated idl

    # The runtime image ships the Go toolchain because kitex runs
    # `go mod init` when it initializes a module for the generated code.
    if ! command -v go >/dev/null 2>&1; then
        printf 'FAIL: go toolchain not found in PATH; kitex needs it to init a module\n' >&2
        return 1
    fi

    if ! command -v grep >/dev/null 2>&1; then
        printf 'FAIL: grep not found in runtime image\n' >&2
        return 1
    fi

    WORKDIR="$(mktemp -d)" || {
        printf 'FAIL: could not create a temporary workspace\n' >&2
        return 1
    }

    idl="${WORKDIR}/echo.thrift"
    cat > "${idl}" <<'IDL'
namespace go demo

struct EchoRequest {
    1: string message
}

struct EchoResponse {
    1: string message
}

service EchoService {
    EchoResponse Echo(1: EchoRequest req)
}
IDL

    # -no-dependency-check keeps the run offline; code generation itself runs
    # the embedded thriftgo SDK and does not fetch anything.
    if output="$(cd "${WORKDIR}" && "${BINARY}" -module example.com/hello -no-dependency-check echo.thrift 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: code generation exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != *"Code Generation is Done!"* ]]; then
        printf 'FAIL: missing generation-complete marker: %s\n' "${output}" >&2
        return 1
    fi

    generated="${WORKDIR}/kitex_gen/demo/echo.go"
    if [[ ! -f "${generated}" ]]; then
        printf 'FAIL: expected generated file is missing: %s\n' "${generated}" >&2
        return 1
    fi

    if ! grep -Fq 'type EchoRequest struct' "${generated}"; then
        printf 'FAIL: generated request struct not found in %s\n' "${generated}" >&2
        return 1
    fi

    if ! grep -Fq 'type EchoService interface' "${generated}"; then
        printf 'FAIL: generated service interface not found in %s\n' "${generated}" >&2
        return 1
    fi

    if ! grep -Fq 'serviceName := "EchoService"' \
        "${WORKDIR}/kitex_gen/demo/echoservice/echoservice.go"; then
        printf 'FAIL: generated service package is missing service metadata\n' >&2
        return 1
    fi

    printf 'PASS: thrift code generation produced kitex_gen service code\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_code_generation; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
