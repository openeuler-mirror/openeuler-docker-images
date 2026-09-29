#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

JAVA_BIN="java"
JAR="/usr/local/lib/junit-platform-console-standalone.jar"
VERSION_LINE_PREFIX="JUnit Platform Console Launcher "

if ! command -v "${JAVA_BIN}" >/dev/null 2>&1; then
    printf 'FAIL: java runtime is not available on PATH\n' >&2
    exit 1
fi

if [[ ! -f "${JAR}" ]]; then
    printf 'FAIL: console launcher jar not found: %s\n' "${JAR}" >&2
    exit 1
fi

WORK_DIR=""
cleanup() {
    if [[ -n "${WORK_DIR:-}" ]]; then
        rm -rf "${WORK_DIR}"
    fi
}
trap cleanup EXIT

run_launcher() {
    "${JAVA_BIN}" -jar "${JAR}" --disable-ansi-colors "$@"
}

test_version() {
    local output line found=""

    if ! output="$(run_launcher --version 2>&1)"; then
        printf 'FAIL: launcher --version failed:\n%s\n' "${output}" >&2
        return 1
    fi

    while IFS= read -r line; do
        if [[ "${line}" == "${VERSION_LINE_PREFIX}"* ]]; then
            found="${line#"${VERSION_LINE_PREFIX}"}"
            break
        fi
    done <<< "${output}"

    if [[ -z "${found}" ]]; then
        printf 'FAIL: no "%s" line in version output:\n%s\n' \
            "${VERSION_LINE_PREFIX}" "${output}" >&2
        return 1
    fi

    if [[ "${found}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${found}" >&2
        return 1
    fi

    printf 'PASS: exact launcher version: %s\n' "${found}"
}

test_engines() {
    local output line
    local expected="junit-jupiter (org.junit.jupiter:junit-jupiter-engine:${EXPECTED_VERSION})"
    local seen=0

    if ! output="$(run_launcher engines 2>&1)"; then
        printf 'FAIL: launcher engines failed:\n%s\n' "${output}" >&2
        return 1
    fi

    while IFS= read -r line; do
        if [[ "${line}" == "${expected}" ]]; then
            seen=1
            break
        fi
    done <<< "${output}"

    if (( seen != 1 )); then
        printf 'FAIL: jupiter engine not listed as <%s>:\n%s\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    printf 'PASS: bundled jupiter engine: %s\n' "${expected}"
}

summary_count() {
    local output="$1" label="$2" line

    while IFS= read -r line; do
        if [[ "${line}" == *"${label}"* ]]; then
            line="${line//[\[\]]/ }"
            line="${line//${label}/ }"
            set -- ${line}
            printf '%s' "${1:-}"
            return 0
        fi
    done <<< "${output}"

    return 1
}

test_execute() {
    local work src classes output rc found started successful failed

    WORK_DIR="$(mktemp -d)"
    work="${WORK_DIR}"
    src="${work}/src"
    classes="${work}/classes"
    mkdir -p "${src}/example" "${classes}"

    cat > "${src}/example/ImageSelfTest.java" <<'JAVA'
package example;

import static org.junit.jupiter.api.Assertions.assertEquals;
import org.junit.jupiter.api.Test;

class ImageSelfTest {

    @Test
    void arithmeticIsCorrect() {
        assertEquals(42, 6 * 7);
    }
}
JAVA

    # The runtime image installs java-17-openjdk-headless, which ships the
    # jdk.compiler module but not the javac launcher binary.
    if ! output="$("${JAVA_BIN}" -m jdk.compiler/com.sun.tools.javac.Main \
            -cp "${JAR}" -d "${classes}" "${src}/example/ImageSelfTest.java" 2>&1)"; then
        rc=$?
        printf 'FAIL: compiling the fixture test failed (exit %s):\n%s\n' \
            "${rc}" "${output}" >&2
        return 1
    fi

    if ! output="$(run_launcher execute --class-path "${classes}" \
            --scan-class-path --details=tree 2>&1)"; then
        rc=$?
        printf 'FAIL: launcher execute exited %s:\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != *"ImageSelfTest"* ]] || \
       [[ "${output}" != *"arithmeticIsCorrect()"* ]]; then
        printf 'FAIL: executed test not reported in output:\n%s\n' "${output}" >&2
        return 1
    fi

    if ! found="$(summary_count "${output}" "tests found")"; then
        printf 'FAIL: no test summary in output:\n%s\n' "${output}" >&2
        return 1
    fi
    if ! started="$(summary_count "${output}" "tests started")"; then
        printf 'FAIL: no test summary in output:\n%s\n' "${output}" >&2
        return 1
    fi
    if ! successful="$(summary_count "${output}" "tests successful")"; then
        printf 'FAIL: no test summary in output:\n%s\n' "${output}" >&2
        return 1
    fi
    if ! failed="$(summary_count "${output}" "tests failed")"; then
        printf 'FAIL: no test summary in output:\n%s\n' "${output}" >&2
        return 1
    fi

    if [[ "${found}" != "1" || "${started}" != "1" || \
          "${successful}" != "1" || "${failed}" != "0" ]]; then
        printf 'FAIL: unexpected test summary: found=%s started=%s successful=%s failed=%s\n' \
            "${found}" "${started}" "${successful}" "${failed}" >&2
        return 1
    fi

    printf 'PASS: execute discovered and passed 1 real Jupiter test\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_engines; then
        failures=$((failures + 1))
    fi
    if ! test_execute; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
