#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

BINARY="gradle"
BINARY_PATH="/opt/gradle/bin/gradle"
MARKER="oe-gradle-smoke-ok"
WORKDIR=""

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_version() {
    local resolved output line reported="" rc=0

    if ! command -v "${BINARY}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found on PATH: %s\n' "${BINARY}" >&2
        return 1
    fi

    resolved="$(command -v "${BINARY}")"
    if [[ "${resolved}" != "${BINARY_PATH}" ]]; then
        printf 'FAIL: %s resolved to <%s>, expected <%s> (GRADLE_HOME=/opt/gradle)\n' \
            "${BINARY}" "${resolved}" "${BINARY_PATH}" >&2
        return 1
    fi

    if output="$("${BINARY}" --version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: gradle --version exited %s:\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi

    while IFS= read -r line; do
        case "${line}" in
            "Gradle "*)
                reported="${line#Gradle }"
                break
                ;;
        esac
    done <<< "${output}"

    if [[ -z "${reported}" ]]; then
        printf 'FAIL: no "Gradle <version>" line found in --version output:\n%s\n' \
            "${output}" >&2
        return 1
    fi

    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${reported}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${reported}"
}

test_core_build() {
    local project output result actual rc=0

    WORKDIR="$(mktemp -d)" || return 1
    project="${WORKDIR}/project"
    mkdir -p "${project}"

    printf '%s\n' "rootProject.name = 'oe-gradle-smoke'" > "${project}/settings.gradle"

    cat > "${project}/build.gradle" <<'EOF'
tasks.register('oeSmokeTest', Copy) {
    from 'smoke-result.txt'
    into 'build/smoke-out'
}
EOF

    printf '%s\n' "${MARKER}" > "${project}/smoke-result.txt"

    if output="$(
        GRADLE_USER_HOME="${WORKDIR}/gradle-home" \
        "${BINARY}" \
            --offline \
            --no-daemon \
            --non-interactive \
            -q \
            --project-dir "${project}" \
            oeSmokeTest 2>&1
    )"; then
        :
    else
        rc=$?
        printf 'FAIL: gradle task "oeSmokeTest" exited %s:\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi

    result="${project}/build/smoke-out/smoke-result.txt"
    if [[ ! -f "${result}" ]]; then
        printf 'FAIL: task produced no output at <%s>\n' "${result}" >&2
        printf 'gradle output:\n%s\n' "${output}" >&2
        return 1
    fi

    actual="$(< "${result}")"
    if [[ "${actual}" != "${MARKER}" ]]; then
        printf 'FAIL: copied content mismatch: expected=<%s> actual=<%s>\n' \
            "${MARKER}" "${actual}" >&2
        return 1
    fi

    printf 'PASS: gradle configured the project and executed task oeSmokeTest '
    printf '(read smoke-result.txt, copied it to build/smoke-out)\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_core_build; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
