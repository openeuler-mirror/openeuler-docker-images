#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

BINARY="hz"
BINARY_PATH="/usr/local/bin/hz"
MODULE="example.com/hertz-smoke"

VERSION="${EXPECTED_VERSION#v}"

# hz embeds its own version in cmd/hz/meta/const.go, independent of the hertz
# release tag. At tag v0.10.6 that constant is still "v0.9.7", and hz prints it
# via urfave/cli as "<app name> version <constant>". Map the release requested
# by the task to the constant the pinned source actually declares so the
# comparison is still an exact match rather than a fuzzy substring.
case "${VERSION}" in
    0.10.6) REPORTED_VERSION="v0.9.7" ;;
    *) REPORTED_VERSION="v${VERSION}" ;;
esac

WORKDIR=""

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_version() {
    local output rc actual

    if ! command -v "${BINARY}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found in PATH: %s\n' "${BINARY}" >&2
        return 1
    fi

    if [[ ! -x "${BINARY_PATH}" ]]; then
        printf 'FAIL: expected binary is not executable: %s\n' "${BINARY_PATH}" >&2
        return 1
    fi

    if output="$("${BINARY}" --version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: version command exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "hz version "* ]]; then
        printf 'FAIL: unexpected version output format: <%s>\n' "${output}" >&2
        return 1
    fi

    actual="${output#hz version }"
    if [[ "${actual}" != "${REPORTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s> (full output: <%s>)\n' \
            "${REPORTED_VERSION}" "${actual}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${output}"
}

assert_file_contains() {
    local file="$1" needle="$2" label="$3" content

    if [[ ! -f "${file}" ]]; then
        printf 'FAIL: expected generated file is missing (%s): %s\n' \
            "${label}" "${file}" >&2
        return 1
    fi

    content="$(<"${file}")"
    if [[ "${content}" != *"${needle}"* ]]; then
        printf 'FAIL: %s: pattern not found in %s: <%s>\n' \
            "${label}" "${file}" "${needle}" >&2
        return 1
    fi

    printf 'PASS: %s\n' "${label}"
}

test_generate_layout() {
    local output rc gopath

    if ! command -v mktemp >/dev/null 2>&1; then
        printf 'FAIL: mktemp not found in runtime image\n' >&2
        return 1
    fi

    WORKDIR="$(mktemp -d)" || {
        printf 'FAIL: could not create a temporary workspace\n' >&2
        return 1
    }
    gopath="${WORKDIR}/gopath"
    mkdir -p "${gopath}"

    # With no --idl hz only scaffolds the project layout: TriggerPlugin returns
    # immediately for an empty IdlPaths list, so no thriftgo/protoc install and
    # no network access is triggered. A GOPATH directory must exist because
    # checkPackage rejects an empty/absent GOPATH before generating anything.
    if output="$(cd "${WORKDIR}" && GOPATH="${gopath}" "${BINARY}" new --module "${MODULE}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: hz new exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if ! assert_file_contains "${WORKDIR}/main.go" 'func main()' 'main.go entrypoint'; then
        return 1
    fi
    if ! assert_file_contains "${WORKDIR}/main.go" 'h.Spin()' 'main.go server start'; then
        return 1
    fi
    if ! assert_file_contains "${WORKDIR}/go.mod" "module ${MODULE}" 'go.mod module path'; then
        return 1
    fi
    if ! assert_file_contains "${WORKDIR}/biz/handler/ping.go" '"message": "pong"' 'ping handler response'; then
        return 1
    fi
    if ! assert_file_contains "${WORKDIR}/biz/router/register.go" 'func GeneratedRegister(r *server.Hertz)' 'generated router registration'; then
        return 1
    fi
    if ! assert_file_contains "${WORKDIR}/router_gen.go" 'func register(r *server.Hertz)' 'router entrypoint'; then
        return 1
    fi
    if ! assert_file_contains "${WORKDIR}/.hz" 'hz version:' 'project manifest'; then
        return 1
    fi

    printf 'PASS: hz new generated a Hertz project layout\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_generate_layout; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
