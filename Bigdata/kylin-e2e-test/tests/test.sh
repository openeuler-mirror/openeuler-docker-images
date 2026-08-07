#!/bin/bash
set -e; set -o pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

KYLIN_HOME="${KYLIN_HOME:-/home/kylin/apache-kylin-${EXPECTED_VERSION}-bin}"
BASE_URL="http://localhost:7070/kylin"
READY_TIMEOUT=600
AUTH_USER="ADMIN"
AUTH_PASS="KYLIN"

log_fail() {
    echo "FAIL: $*"
}

http_get_json() {
    wget -q --timeout=30 --auth-no-challenge --user="${AUTH_USER}" --password="${AUTH_PASS}" -O - "$1" 2>/dev/null
}

wait_for_ready() {
    local deadline=$((SECONDS + READY_TIMEOUT))
    local body
    while [ $SECONDS -lt $deadline ]; do
        body=$(wget -q --timeout=10 --auth-no-challenge --user="${AUTH_USER}" --password="${AUTH_PASS}" -O - "${BASE_URL}/api/user/authentication" 2>/dev/null || true)
        if printf '%s' "$body" | grep -Fq '"username":"'"${AUTH_USER}"'"'; then
            echo "PASS: kylin REST server ready on port 7070 (authenticated user ${AUTH_USER})"
            return 0
        fi
        sleep 5
    done
    echo "FAIL: kylin REST server did not become ready within ${READY_TIMEOUT}s"
    echo "      probed GET ${BASE_URL}/api/user/authentication with HTTP Basic ${AUTH_USER}/${AUTH_PASS} expecting HTTP 200 + username"
    if [ -f "${KYLIN_HOME}/logs/kylin.log" ]; then
        echo "---- tail of ${KYLIN_HOME}/logs/kylin.log ----"
        tail -n 40 "${KYLIN_HOME}/logs/kylin.log" 2>/dev/null || true
    fi
    return 1
}

test_version() {
    local version_file="${KYLIN_HOME}/VERSION"
    if [ ! -f "$version_file" ]; then
        log_fail "kylin VERSION file not found: ${version_file}"
        return 1
    fi
    local reported
    reported=$(grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' "$version_file" | head -n 1)
    if [ -n "$reported" ] && [ "$reported" = "$EXPECTED_VERSION" ]; then
        echo "PASS: kylin version ${reported} matches expected ${EXPECTED_VERSION}"
        return 0
    fi
    log_fail "kylin version '${reported}' does not match expected '${EXPECTED_VERSION}' (file: ${version_file})"
    return 1
}

test_authentication() {
    local body
    body=$(http_get_json "${BASE_URL}/api/user/authentication") || {
        log_fail "GET ${BASE_URL}/api/user/authentication (HTTP Basic ${AUTH_USER}/${AUTH_PASS}) failed"
        return 1
    }
    if printf '%s' "$body" | grep -Fq '"username":"'"${AUTH_USER}"'"'; then
        echo "PASS: kylin server authenticated user ${AUTH_USER}"
        return 0
    fi
    log_fail "expected authenticated user ${AUTH_USER}, got: $(printf '%s' "$body" | head -c 400)"
    return 1
}

test_projects() {
    local body
    body=$(http_get_json "${BASE_URL}/api/projects") || {
        log_fail "GET ${BASE_URL}/api/projects (HTTP Basic ${AUTH_USER}/${AUTH_PASS}) failed"
        return 1
    }
    if printf '%s' "$body" | grep -Fq "learn_kylin"; then
        echo "PASS: kylin server lists sample project learn_kylin"
        return 0
    fi
    log_fail "sample project learn_kylin missing from projects response: $(printf '%s' "$body" | head -c 400)"
    return 1
}

test_models() {
    local body
    body=$(http_get_json "${BASE_URL}/api/models?projectName=learn_kylin") || {
        log_fail "GET ${BASE_URL}/api/models?projectName=learn_kylin (HTTP Basic ${AUTH_USER}/${AUTH_PASS}) failed"
        return 1
    }
    if printf '%s' "$body" | grep -Fq "SSB.P_LINEORDER"; then
        echo "PASS: kylin server exposes sample model (fact table SSB.P_LINEORDER) in project learn_kylin"
        return 0
    fi
    log_fail "sample model missing from models response: $(printf '%s' "$body" | head -c 400)"
    return 1
}

main() {
    local failures=0
    wait_for_ready || failures=$((failures + 1))
    test_version || failures=$((failures + 1))
    test_authentication || failures=$((failures + 1))
    test_projects || failures=$((failures + 1))
    test_models || failures=$((failures + 1))
    if [ "$failures" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        exit 0
    fi
    echo "TESTS_FAILED: ${failures} failures"
    exit 1
}

main "$@"
