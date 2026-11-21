#!/bin/bash
# KunpengTest functional test for openjdk.
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version dir name, e.g. "28+24"), DOCKER_NAMESPACE,
# DOCKER_PACKAGE, DOCKER_TAG, DOCKER_IMAGE.
#
# openjdk is a JDK (CLI toolchain) with no long-running service. Tests verify:
#   1) java reports exactly ${EXPECTED_VERSION} (parsed from the runtime build
#      string emitted by "java --version", e.g. "28-ea+24-2291" -> "28+24");
#   2) a real compile-and-run round-trip with javac/java.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

JAVA_BIN="java"
JAVAC_BIN="javac"
WORKDIR=""

cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_version() {
    local out runtime_version feature build reported
    if ! command -v "${JAVA_BIN}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found in PATH: %s\n' "${JAVA_BIN}"
        return 1
    fi
    out="$("${JAVA_BIN}" --version 2>&1 || true)"
    runtime_version=""
    if [[ "${out}" =~ build[[:space:]]+([0-9a-zA-Z.+_-]+) ]]; then
        runtime_version="${BASH_REMATCH[1]}"
    fi
    if [ -z "${runtime_version}" ]; then
        printf 'FAIL: could not parse build version from "%s --version" output\n' "${JAVA_BIN}"
        return 1
    fi
    reported=""
    if [[ "${runtime_version}" =~ ^([0-9]+)[^+]*\+([0-9]+) ]]; then
        feature="${BASH_REMATCH[1]}"
        build="${BASH_REMATCH[2]}"
        reported="${feature}+${build}"
    fi
    if [ -z "${reported}" ]; then
        printf 'FAIL: unexpected runtime version format: <%s>\n' "${runtime_version}"
        return 1
    fi
    if [ "${reported}" != "${EXPECTED_VERSION}" ]; then
        printf 'FAIL: version mismatch: expected <%s> actual <%s>\n' \
            "${EXPECTED_VERSION}" "${reported}"
        return 1
    fi
    printf 'PASS: exact version %s\n' "${reported}"
}

test_core_function() {
    local out src cls
    if ! command -v "${JAVA_BIN}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found in PATH: %s\n' "${JAVA_BIN}"
        return 1
    fi
    if ! command -v "${JAVAC_BIN}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found in PATH: %s\n' "${JAVAC_BIN}"
        return 1
    fi
    WORKDIR="$(mktemp -d)"
    src="${WORKDIR}/Hello.java"
    cls="${WORKDIR}/Hello.class"
    cat > "${src}" <<'JAVA'
public class Hello {
    public static void main(String[] args) {
        System.out.println("OPENJDK_PROBE_OK");
    }
}
JAVA
    if ! out="$("${JAVAC_BIN}" -d "${WORKDIR}" "${src}" 2>&1)"; then
        printf 'FAIL: javac failed: %s\n' "$(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-300)"
        return 1
    fi
    if [ ! -f "${cls}" ]; then
        printf 'FAIL: compiled class not produced: %s\n' "${cls}"
        return 1
    fi
    if ! out="$("${JAVA_BIN}" -cp "${WORKDIR}" Hello 2>&1)"; then
        printf 'FAIL: java run failed: %s\n' "$(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-300)"
        return 1
    fi
    if [ "${out}" != "OPENJDK_PROBE_OK" ]; then
        printf 'FAIL: unexpected program output: <%s>\n' "${out}"
        return 1
    fi
    printf 'PASS: javac compile + java run round-trip\n'
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
