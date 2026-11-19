#!/bin/bash
# KunpengTest functional test for jetty (version only).
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version dir name), DOCKER_NAMESPACE, DOCKER_PACKAGE,
# DOCKER_TAG, DOCKER_IMAGE.
#
# The image extracts the jetty-home 12.1.x tarball into /usr/local/jetty, so the
# distribution ships its own version stamp at $JETTY_HOME/VERSION.txt (first
# line: "12.1.15 - 05 November 2026").  `java -jar start.jar --version` run with
# the entrypoint overridden does not resolve a classpath and prints
# "No classpath entries and/or version information available", so the test reads
# the installed VERSION.txt first and only falls back to start.jar / jar names.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

APP_NAME="jetty"
JETTY_HOME="${JETTY_HOME:-/usr/local/jetty}"
JETTY_BASE="${JETTY_BASE:-/var/lib/jetty}"
export JETTY_HOME JETTY_BASE

prepare_environment() {
    local dir
    if ! command -v java >/dev/null 2>&1; then
        for dir in /usr/lib/jvm/java-17-openjdk/bin \
                   /usr/lib/jvm/jre-17/bin \
                   /usr/lib/jvm/java-21-openjdk/bin \
                   /usr/lib/jvm/*/bin; do
            if [ -x "${dir}/java" ]; then
                PATH="${dir}:${PATH}"
                export PATH
                break
            fi
        done
    fi
    if [ -d "${JETTY_BASE}" ]; then
        cd "${JETTY_BASE}" 2>/dev/null || true
    fi
}

find_bin() {
    local name="$1" p
    for p in "/usr/local/bin/${name}" "/usr/bin/${name}" "/bin/${name}" \
             "/usr/local/sbin/${name}" "/usr/sbin/${name}" "/sbin/${name}"; do
        if [ -x "${p}" ]; then
            printf '%s\n' "${p}"
            return 0
        fi
    done
    command -v "${name}" 2>/dev/null && return 0
    return 1
}

app_version_output() {
    local vfile first java_bin out jar
    vfile="${JETTY_HOME}/VERSION.txt"
    if [ -r "${vfile}" ]; then
        first="$(sed -n '1p' "${vfile}" 2>/dev/null || true)"
        if [ -n "${first}" ]; then
            printf '%s\n' "${first}"
            return 0
        fi
    fi
    java_bin="$(find_bin "java")" || true
    if [ -n "${java_bin}" ] && [ -f "${JETTY_HOME}/start.jar" ]; then
        out="$("${java_bin}" -jar "${JETTY_HOME}/start.jar" --version 2>&1 || true)"
        if [ -n "${out}" ]; then
            printf '%s\n' "${out}"
            return 0
        fi
    fi
    for jar in "${JETTY_HOME}"/lib/jetty-util-*.jar "${JETTY_HOME}"/lib/jetty-server-*.jar; do
        [ -f "${jar}" ] || continue
        printf '%s\n' "$(basename "${jar}" .jar)"
        return 0
    done
    return 1
}

version_matches() {
    local token="$1" part
    token="${token#v}"; token="${token#V}"
    [ "${token}" = "${EXPECTED_VERSION}" ] && return 0
    while IFS= read -r part; do
        [ -n "${part}" ] || continue
        part="${part#v}"; part="${part#V}"
        [ "${part}" = "${EXPECTED_VERSION}" ] && return 0
    done < <(printf '%s\n' "${token}" | tr '/-' '\n')
    if [[ "${token}" =~ ^([0-9]+(\.[0-9A-Za-z]+)+) ]] && [ "${BASH_REMATCH[1]}" = "${EXPECTED_VERSION}" ]; then
        return 0
    fi
    return 1
}

test_version() {
    local out token
    out="$(app_version_output 2>&1 || true)"
    if [ -z "${out}" ]; then
        printf 'FAIL: %s produced no version output\n' "${APP_NAME}"
        return 1
    fi
    for token in $(printf '%s\n' "${out}" | tr -c 'A-Za-z0-9._+-' ' '); do
        if version_matches "${token}"; then
            printf 'PASS: %s reports version %s\n' "${APP_NAME}" "${EXPECTED_VERSION}"
            return 0
        fi
    done
    printf 'FAIL: expected %s version %s, got: %s\n' "${APP_NAME}" "${EXPECTED_VERSION}" \
        "$(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-300)"
    return 1
}

main() {
    local failures=0
    prepare_environment
    test_version || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"
