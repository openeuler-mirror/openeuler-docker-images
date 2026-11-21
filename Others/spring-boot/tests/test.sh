#!/bin/bash
# KunpengTest functional test for spring-boot.
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version dir name), DOCKER_NAMESPACE, DOCKER_PACKAGE,
# DOCKER_TAG, DOCKER_IMAGE.
#
# This image is a service: CMD runs
#   java -jar /home/spring-boot/target/demo-1.0.jar
# which serves the demo Spring MVC controller returning "Hello World!" at "/"
# on port 8080 (EXPOSE 8080). The service does not auto-start, so the test
# starts it in the background, polls for readiness and exercises the HTTP path.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

JAR="/home/spring-boot/target/demo-1.0.jar"
SERVER_PID=""
WORKDIR=""

cleanup() {
    if [ -n "${SERVER_PID}" ]; then
        kill "${SERVER_PID}" 2>/dev/null
        wait "${SERVER_PID}" 2>/dev/null
    fi
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

# The executable jar embeds its runtime dependency jars under BOOT-INF/lib/.
# Jar entry names are stored uncompressed in the archive, so the core
# "spring-boot-<version>.jar" entry name is greppable and yields the exact
# Spring Boot version (see spring-boot-autoconfigure's dependency on
# org.springframework.boot:spring-boot in the upstream build).
test_version() {
    local matches version
    if [ ! -f "${JAR}" ]; then
        echo "FATAL: application jar not found: ${JAR}"
        return 1
    fi
    matches="$(grep -aoE 'spring-boot-[0-9][0-9A-Za-z.]*\.jar' "${JAR}" 2>/dev/null | sort -u)"
    version="$(printf '%s\n' "${matches}" | sed -E 's/^spring-boot-([0-9][0-9A-Za-z.]*)\.jar$/\1/' | head -n1)"
    if [ -n "${version}" ] && [ "${version}" = "${EXPECTED_VERSION}" ]; then
        echo "PASS: exact spring-boot version ${version}"
        return 0
    fi
    echo "FAIL: expected spring-boot ${EXPECTED_VERSION}, got '${version}'"
    return 1
}

test_core_function() {
    local body i
    if [ ! -f "${JAR}" ]; then
        echo "FATAL: application jar not found: ${JAR}"
        return 1
    fi
    WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/spring-boot-test.XXXXXX")"
    java -jar "${JAR}" > "${WORKDIR}/server.log" 2>&1 &
    SERVER_PID=$!

    body=""
    i=0
    while [ "${i}" -lt 30 ]; do
        i=$((i + 1))
        if body="$(wget -q -O - http://127.0.0.1:8080/ 2>/dev/null)"; then
            break
        fi
        if ! kill -0 "${SERVER_PID}" 2>/dev/null; then
            body=""
            break
        fi
        sleep 1
    done

    if [ -z "${body}" ]; then
        echo "FAIL: spring-boot http endpoint did not become ready on 8080"
        return 1
    fi
    if [ "${body}" != "Hello World!" ]; then
        echo "FAIL: unexpected response from /: '${body}'"
        return 1
    fi
    echo "PASS: serving 'Hello World!' at http://127.0.0.1:8080/"
    return 0
}

main() {
    local failures=0
    test_version       || failures=$((failures + 1))
    test_core_function || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        return 0
    fi
    echo "TESTS_FAILED: ${failures} failure(s)"
    return 1
}

main "$@"