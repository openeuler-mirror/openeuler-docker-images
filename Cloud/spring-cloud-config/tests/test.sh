#!/bin/bash
# In-container tests for the openeuler/spring-cloud-config image.
#
# NOTE: this script is executed by the CI testrunner INSIDE the image under
# test (docker run --entrypoint bash <image> /tmp/eptest/test.sh), so it must
# not rely on docker or host networking. It verifies:
#   T-1 image version matches EXPECTED_VERSION (--version equivalent)
#   T-2 bundled jar contains the spring-cloud-config-server component
#   T-3 the application boots with a native repo and listens on its port
#
# The config server requires a repository config to serve; the boot test
# points it at an ephemeral native repo created inside the test container.
#
# Optional env:
#   EXPECTED_VERSION   component version the image was built for (e.g. 5.0.6)
#   APP_PORT           port the app listens on (default 8888)

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

APP_JAR="/app/app.jar"
VERSION_FILE="/app/IMAGE_VERSION"
APP_PORT="${APP_PORT:-8888}"
STARTER_JAR="BOOT-INF/lib/spring-cloud-config-server-${EXPECTED_VERSION}.jar"

fail() {
    printf 'FAIL: %s\n' "$1" >&2
    return 1
}

pass() {
    printf 'PASS: %s\n' "$1"
}

port_open() {
    (exec 3<>"/dev/tcp/127.0.0.1/${APP_PORT}") 2>/dev/null || return 1
    exec 3>&- 3<&- 2>/dev/null || true
}

wait_port() {
    local timeout="$1" i
    for (( i = 0; i < timeout; i += 2 )); do
        if port_open; then
            return 0
        fi
        sleep 2
    done
    return 1
}

stop_app() {
    if [[ -n "${APP_PID:-}" ]]; then
        kill "${APP_PID}" >/dev/null 2>&1 || true
        wait "${APP_PID}" 2>/dev/null || true
        APP_PID=""
    fi
}

main() {
    local failures=0

    # ---------- T-1: version ----------
    local ver
    if ver="$(cat "${VERSION_FILE}" 2>/dev/null)"; then
        if [[ "${ver}" == *" ${EXPECTED_VERSION} "* ]]; then
            pass "T-1 image version matches expectation: ${ver}"
        else
            printf 'FAIL: T-1 version mismatch: expected %s in <%s>\n' "${EXPECTED_VERSION}" "${ver}" >&2
            failures=$((failures + 1))
        fi
    else
        printf 'FAIL: T-1 cannot read %s\n' "${VERSION_FILE}" >&2
        failures=$((failures + 1))
    fi

    # ---------- T-2: component jar bundled ----------
    if grep -aq "${STARTER_JAR}" "${APP_JAR}" 2>/dev/null; then
        pass "T-2 bundled jar contains ${STARTER_JAR}"
    else
        printf 'FAIL: T-2 component jar not found in image: %s\n' "${STARTER_JAR}" >&2
        failures=$((failures + 1))
    fi

    # ---------- T-3: application boots (native profile) and listens ----------
    stop_app
    mkdir -p /tmp/nativerepo
    printf 'demo:\n  message: ci-ok\n' > /tmp/nativerepo/application.yml
    SPRING_PROFILES_ACTIVE=native \
    SPRING_CLOUD_CONFIG_SERVER_NATIVE_SEARCHLOCATIONS="file:/tmp/nativerepo" \
        java -jar "${APP_JAR}" >/tmp/app.log 2>&1 &
    APP_PID=$!
    if wait_port 180; then
        pass "T-3 application started and listens on port ${APP_PORT}"
    else
        printf 'FAIL: T-3 application did not open port %s within 180s; app log tail:\n' "${APP_PORT}" >&2
        tail -20 /tmp/app.log >&2 || true
        failures=$((failures + 1))
    fi
    stop_app

    if [[ "${failures}" -eq 0 ]]; then
        printf 'ALL_TESTS_PASSED\n'
    else
        printf 'TESTS_FAILED: %d failure(s)\n' "${failures}" >&2
        exit 1
    fi
}

main "$@"
