#!/bin/bash
set -euo pipefail

# Inclusion-level tests for the openeuler/spring-cloud-vault image.
# The vault integration is a client library (disabled by default), so these
# tests verify the image is runnable and the component is really bundled:
#   V-1 container starts and reports health UP
#   V-2 image version matches expectation (--version equivalent)
#   V-3 bundled jar contains the spring-cloud-vault starter
#
# Required env:
#   EXPECTED_VERSION   vault component version the image was built for (e.g. 5.1.0)
# Optional env:
#   IMAGE              image ref (default openeuler/spring-cloud-vault:${EXPECTED_VERSION}-oe2403sp4)
#   SVC_PORT           host port for the test server (default 18890)

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

IMAGE="${IMAGE:-openeuler/spring-cloud-vault:${EXPECTED_VERSION}-oe2403sp4}"
SVC_PORT="${SVC_PORT:-18890}"

cleanup() {
    docker rm -f scvault-svc >/dev/null 2>&1 || true
}
trap cleanup EXIT

fail() {
    printf 'FAIL: %s\n' "$1" >&2
    return 1
}

pass() {
    printf 'PASS: %s\n' "$1"
}

poll_http() {
    local url="$1" needle="$2" timeout="$3" label="$4" i body
    for (( i = 0; i < timeout; i += 2 )); do
        if body="$(curl -fsS --max-time 5 "${url}" 2>/dev/null)"; then
            if [[ "${body}" == *"${needle}"* ]]; then
                pass "${label}"
                return 0
            fi
        fi
        sleep 2
    done
    fail "${label}: last body: ${body:0:300}"
}

main() {
    for tool in docker curl; do
        if ! command -v "${tool}" >/dev/null 2>&1; then
            printf 'FAIL: required tool missing on host: %s\n' "${tool}" >&2
            exit 1
        fi
    done

    local failures=0

    # ---------- V-1: startup + health ----------
    docker run -d --name scvault-svc \
        -p "${SVC_PORT}:8080" \
        "${IMAGE}" >/dev/null
    local svc_url="http://127.0.0.1:${SVC_PORT}"

    if poll_http "${svc_url}/actuator/health" '"UP"' 180 "V-1 container starts and reports health UP"; then
        :
    else
        failures=$((failures + 1))
        docker logs --tail 50 scvault-svc 2>&1 || true
    fi

    # ---------- V-2: version (--version equivalent) ----------
    local ver
    if ver="$(docker exec scvault-svc cat /app/IMAGE_VERSION 2>/dev/null)"; then
        if [[ "${ver}" == *" ${EXPECTED_VERSION} "* ]]; then
            pass "V-2 image version matches expectation: ${ver}"
        else
            printf 'FAIL: V-2 version mismatch: expected %s in <%s>\n' "${EXPECTED_VERSION}" "${ver}" >&2
            failures=$((failures + 1))
        fi
    else
        printf 'FAIL: V-2 cannot read /app/IMAGE_VERSION\n' >&2
        failures=$((failures + 1))
    fi

    # ---------- V-3: starter jar bundled ----------
    local jar_entry="BOOT-INF/lib/spring-cloud-starter-vault-config-${EXPECTED_VERSION}.jar"
    if docker exec scvault-svc grep -aq "${jar_entry}" /app/app.jar 2>/dev/null; then
        pass "V-3 bundled jar contains ${jar_entry}"
    else
        printf 'FAIL: V-3 starter jar not found in image: %s\n' "${jar_entry}" >&2
        failures=$((failures + 1))
    fi

    if [[ "${failures}" -eq 0 ]]; then
        printf 'ALL_TESTS_PASSED\n'
    else
        printf 'TESTS_FAILED: %d failure(s)\n' "${failures}" >&2
        exit 1
    fi
}

main "$@"
