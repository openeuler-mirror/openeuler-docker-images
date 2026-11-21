#!/bin/bash

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

SPRING_HOME="/home/spring-framework"

test_version() {
    local pom version_line reported
    pom="${SPRING_HOME}/pom.xml"
    if [ ! -f "${pom}" ]; then
        echo "FAIL: pom.xml not found: ${pom}"
        return 1
    fi
    version_line="$(grep -o '<spring.version>[^<]*</spring.version>' "${pom}" | head -n 1)"
    reported="${version_line#<spring.version>}"
    reported="${reported%</spring.version>}"
    if [ "${reported}" = "${EXPECTED_VERSION}" ]; then
        echo "PASS: spring.version is ${reported}"
        return 0
    fi
    echo "FAIL: expected spring.version ${EXPECTED_VERSION}, got '${reported}'"
    return 1
}

test_core_function() {
    local out rc classpath diag
    if [ ! -f "${SPRING_HOME}/target/classes/com/example/MainApp.class" ]; then
        echo "FAIL: compiled MainApp.class not found"
        return 1
    fi
    if [ ! -f "${SPRING_HOME}/target/classpath.txt" ]; then
        echo "FAIL: classpath.txt not found"
        return 1
    fi
    classpath="$(cat "${SPRING_HOME}/target/classpath.txt")"
    out="$(cd "${SPRING_HOME}" && java -cp "target/classes:${classpath}" com.example.MainApp 2>&1)"
    rc=$?
    if [ ${rc} -ne 0 ]; then
        diag="$(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-300)"
        echo "FAIL: MainApp exited ${rc}: ${diag}"
        return 1
    fi
    if printf '%s' "${out}" | grep -q 'Hello, Spring Framework!'; then
        echo "PASS: Spring context booted and printed greeting"
        return 0
    fi
    diag="$(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-300)"
    echo "FAIL: missing greeting, got: ${diag}"
    return 1
}

main() {
    local failures=0
    test_version || failures=$((failures + 1))
    test_core_function || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        return 0
    fi
    echo "TESTS_FAILED: ${failures} failure(s)"
    return 1
}

main "$@"