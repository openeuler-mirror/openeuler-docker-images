#!/bin/bash
set -euo pipefail

# Inclusion-level tests for the openeuler/spring-cloud-kubernetes image.
# The kubernetes integration is a client library (disabled by default), so
# these tests verify the image is runnable and the component is really
# bundled:
#   K-1 container starts and reports health UP
#   K-2 image version matches expectation (--version equivalent)
#   K-3 bundled jar contains the spring-cloud-kubernetes starter
#
# Required env:
#   EXPECTED_VERSION   kubernetes component version the image was built for (e.g. 5.1.0)
# Optional env:
#   IMAGE              image ref (default openeuler/spring-cloud-kubernetes:${EXPECTED_VERSION}-oe2403sp4)
#   SVC_PORT           host port for the test server (default 18891)

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

IMAGE="${IMAGE:-openeuler/spring-cloud-kubernetes:${EXPECTED_VERSION}-oe2403sp4}"
SVC_PORT="${SVC_PORT:-18891}"

cleanup() {
    docker rm -f sck8s-svc >/dev/null 2>&1 || true
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

    # ---------- K-1: startup + health ----------
    docker run -d --name sck8s-svc \
        -p "${SVC_PORT}:8080" \
        "${IMAGE}" >/dev/null
    local svc_url="http://127.0.0.1:${SVC_PORT}"

    if poll_http "${svc_url}/actuator/health" '"UP"' 180 "K-1 container starts and reports health UP"; then
        :
    else
        failures=$((failures + 1))
        docker logs --tail 50 sck8s-svc 2>&1 || true
    fi

    # ---------- K-2: version (--version equivalent) ----------
    local ver
    if ver="$(docker exec sck8s-svc cat /app/IMAGE_VERSION 2>/dev/null)"; then
        if [[ "${ver}" == *" ${EXPECTED_VERSION} "* ]]; then
            pass "K-2 image version matches expectation: ${ver}"
        else
            printf 'FAIL: K-2 version mismatch: expected %s in <%s>\n' "${EXPECTED_VERSION}" "${ver}" >&2
            failures=$((failures + 1))
        fi
    else
        printf 'FAIL: K-2 cannot read /app/IMAGE_VERSION\n' >&2
        failures=$((failures + 1))
    fi

    # ---------- K-3: starter jar bundled ----------
    local jar_entry="BOOT-INF/lib/spring-cloud-starter-kubernetes-client-${EXPECTED_VERSION}.jar"
    if docker exec sck8s-svc grep -aq "${jar_entry}" /app/app.jar 2>/dev/null; then
        pass "K-3 bundled jar contains ${jar_entry}"
    else
        printf 'FAIL: K-3 starter jar not found in image: %s\n' "${jar_entry}" >&2
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
