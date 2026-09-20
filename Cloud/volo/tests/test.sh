#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

BINARY="volo"
BINARY_PATH="/usr/local/bin/volo"

# volo-cli reports the version of its own crate (volo-cli), not the release
# tag of the workspace. In the pinned source tag volo-thrift-0.12.2,
# volo-cli/Cargo.toml declares version = "0.12.1", so `volo --version` prints
# "volo 0.12.1" even though the image/tag is 0.12.2. Map the requested
# release tag to the constant the pinned source declares; every other value
# falls through to the tag itself so a mismatch is still a hard failure.
REQUESTED_VERSION="${EXPECTED_VERSION#v}"
case "${REQUESTED_VERSION}" in
    0.12.2) EXPECTED_REPORTED_VERSION="volo 0.12.1" ;;
    *) EXPECTED_REPORTED_VERSION="volo ${REQUESTED_VERSION}" ;;
esac

WORKDIR=""

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_binary() {
    local resolved

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

    printf 'PASS: binary present at %s\n' "${BINARY_PATH}"
}

test_version() {
    local output rc

    if output="$("${BINARY}" --version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: version command exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_REPORTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s> (EXPECTED_VERSION=<%s>)\n' \
            "${EXPECTED_REPORTED_VERSION}" "${output}" "${EXPECTED_VERSION}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${output}"
}

test_project_scaffold() {
    local output rc

    WORKDIR="$(mktemp -d)" || {
        printf 'FAIL: could not create a temporary workspace\n' >&2
        return 1
    }

    mkdir -p "${WORKDIR}/idl"
    cat > "${WORKDIR}/idl/demo.thrift" <<'IDL'
namespace rs demo

struct EchoRequest {
    1: required string message,
}

struct EchoResponse {
    1: required string message,
}

service EchoService {
    EchoResponse Echo(1: EchoRequest req),
}
IDL

    # `volo init <name> <idl>` scaffolds a project from a local Thrift IDL:
    # it parses the service, renders the cargo/src/volo-gen templates and
    # writes the volo-gen/volo.yml config. Run it from the workspace so the
    # config records the IDL as a path relative to volo-gen.
    if output="$(cd "${WORKDIR}" && "${BINARY}" init demo-project idl/demo.thrift 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: volo init exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    local config="${WORKDIR}/volo-gen/volo.yml"
    if [[ ! -f "${config}" ]]; then
        printf 'FAIL: generated config is missing: %s\n' "${config}" >&2
        return 1
    fi

    if ! grep -Fq 'protocol: thrift' "${config}"; then
        printf 'FAIL: config does not declare the thrift protocol: %s\n' "${config}" >&2
        return 1
    fi

    if ! grep -Fq '../idl/demo.thrift' "${config}"; then
        printf 'FAIL: config does not reference the input IDL: %s\n' "${config}" >&2
        return 1
    fi

    if ! grep -Fq 'name = "demo_project"' "${WORKDIR}/Cargo.toml"; then
        printf 'FAIL: generated Cargo.toml is missing the project name\n' >&2
        return 1
    fi

    if [[ ! -f "${WORKDIR}/src/bin/server.rs" ]]; then
        printf 'FAIL: generated server entry is missing: %s\n' \
            "${WORKDIR}/src/bin/server.rs" >&2
        return 1
    fi

    # The generated lib.rs implements the trait derived from the IDL service,
    # proving the CLI actually parsed the service, not just copied files.
    if ! grep -Fq 'EchoService' "${WORKDIR}/src/lib.rs"; then
        printf 'FAIL: generated lib.rs does not implement the IDL service\n' >&2
        return 1
    fi

    printf 'PASS: volo init generated a thrift project from the IDL\n'

    # `volo idl add <idl>` reads volo-gen/volo.yml, appends the new service and
    # writes the config back. This is the project's read-modify-write data path.
    cat > "${WORKDIR}/idl/extra.thrift" <<'IDL'
namespace rs extra

struct PingRequest {
    1: required string message,
}

struct PingResponse {
    1: required string message,
}

service PingService {
    PingResponse Ping(1: PingRequest req),
}
IDL

    if output="$(cd "${WORKDIR}/volo-gen" && "${BINARY}" idl add ../idl/extra.thrift 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: volo idl add exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if ! grep -Fq '../idl/extra.thrift' "${config}"; then
        printf 'FAIL: volo idl add did not persist the new IDL: %s\n' "${config}" >&2
        return 1
    fi

    printf 'PASS: volo idl add updated volo-gen/volo.yml\n'
}

main() {
    local failures=0

    if ! test_binary; then
        failures=$((failures + 1))
    fi
    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_project_scaffold; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
