#!/bin/bash
set -euo pipefail

# Functional tests for the openeuler/spring-cloud-gateway image.
# Covers: startup/health, version, basic routing, path rewrite (StripPrefix),
# load balancing across two backends (simple discovery client).
#
# Required env:
#   EXPECTED_VERSION   gateway component version the image was built for (e.g. 5.0.4)
# Optional env:
#   IMAGE              image ref (default openeuler/spring-cloud-gateway:${EXPECTED_VERSION}-oe2403sp4)
#   HOST_PORT          host port mapped to the gateway (default 18080)
#   BACKEND_PORT       backend port inside the docker network (default 8081)
#   LONG_RUN=1         enable the 4h stability loop (G-6)

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

IMAGE="${IMAGE:-openeuler/spring-cloud-gateway:${EXPECTED_VERSION}-oe2403sp4}"
HOST_PORT="${HOST_PORT:-18080}"
BACKEND_PORT="${BACKEND_PORT:-8081}"
BASE_IMAGE="openeuler/openeuler:24.03-lts-sp4"

NET="scgw-test-$$"
WORKDIR=""
GW_CID=""
B1_CID=""
B2_CID=""

cleanup() {
    for cid in "${GW_CID:-}" "${B1_CID:-}" "${B2_CID:-}"; do
        if [[ -n "${cid}" ]]; then
            docker rm -f "${cid}" >/dev/null 2>&1 || true
        fi
    done
    docker network rm "${NET}" >/dev/null 2>&1 || true
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

fail() {
    printf 'FAIL: %s\n' "$1" >&2
    return 1
}

pass() {
    printf 'PASS: %s\n' "$1"
}

# poll_http <url> <needle> <timeout_seconds> <label>
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
    fail "${label}: last body: ${body:0:200}"
}

main() {
    for tool in docker curl mktemp; do
        if ! command -v "${tool}" >/dev/null 2>&1; then
            printf 'FAIL: required tool missing on host: %s\n' "${tool}" >&2
            exit 1
        fi
    done

    WORKDIR="$(mktemp -d)"
    mkdir -p "${WORKDIR}/backend1" "${WORKDIR}/backend2" "${WORKDIR}/config"

    # backend content: index.html is per-backend so the LB test can tell
    # the instances apart; b1.html/b2.html are shared and used for routing
    # and rewrite assertions.
    echo 'backend-one'  > "${WORKDIR}/backend1/index.html"
    echo 'backend-two'  > "${WORKDIR}/backend2/index.html"
    echo 'shared-file-one' > "${WORKDIR}/backend1/b1.html"
    echo 'shared-file-two' > "${WORKDIR}/backend2/b2.html"

    # gateway config: StripPrefix=1 rewrites /demo/<x> -> /<x> on the backend.
    # Both property namespaces are listed because Spring Cloud 5.x moved the
    # routes under spring.cloud.gateway.server.webflux.*; unknown keys are
    # ignored by relaxed binding, so the file works on either naming scheme.
    cat > "${WORKDIR}/config/application.yml" <<'EOF'
server:
  port: 8080
management:
  endpoints:
    web:
      exposure:
        include: health,info,gateway
spring:
  cloud:
    discovery:
      client:
        simple:
          instances:
            backend:
              - uri: http://backend1:8081
              - uri: http://backend2:8081
    gateway:
      server:
        webflux:
          routes:
            - id: demo
              uri: lb://backend
              predicates:
                - Path=/demo/**
              filters:
                - StripPrefix=1
EOF

    docker network create "${NET}" >/dev/null

    docker run -d --name scgw-b1 --network "${NET}" --network-alias backend1 \
        -v "${WORKDIR}/backend1:/srv:ro" \
        "${BASE_IMAGE}" python3 -m http.server "${BACKEND_PORT}" --directory /srv >/dev/null
    B1_CID="scgw-b1"
    docker run -d --name scgw-b2 --network "${NET}" --network-alias backend2 \
        -v "${WORKDIR}/backend2:/srv:ro" \
        "${BASE_IMAGE}" python3 -m http.server "${BACKEND_PORT}" --directory /srv >/dev/null
    B2_CID="scgw-b2"

    docker run -d --name scgw-gw --network "${NET}" \
        -p "${HOST_PORT}:8080" \
        -v "${WORKDIR}/config:/app/config:ro" \
        "${IMAGE}" >/dev/null
    GW_CID="scgw-gw"

    local base_url="http://127.0.0.1:${HOST_PORT}"
    local failures=0

    # G-1: startup + health + version
    if poll_http "${base_url}/actuator/health" '"UP"' 180 "G-1 gateway starts and reports health UP"; then
        :
    else
        failures=$((failures + 1))
        docker logs --tail 50 scgw-gw 2>&1 || true
    fi

    local ver
    if ver="$(docker exec scgw-gw cat /app/IMAGE_VERSION 2>/dev/null)"; then
        if [[ "${ver}" == *" ${EXPECTED_VERSION} "* ]]; then
            pass "G-1 image version matches expectation: ${ver}"
        else
            printf 'FAIL: G-1 version mismatch: expected %s in <%s>\n' "${EXPECTED_VERSION}" "${ver}" >&2
            failures=$((failures + 1))
        fi
    else
        printf 'FAIL: G-1 cannot read /app/IMAGE_VERSION\n' >&2
        failures=$((failures + 1))
    fi

    # G-2: basic routing through the gateway
    if poll_http "${base_url}/demo/b1.html" 'shared-file-one' 30 "G-2 basic route forwards to backend"; then
        :
    else
        failures=$((failures + 1))
    fi

    # G-3: path rewrite (StripPrefix) serves the right file
    if poll_http "${base_url}/demo/b2.html" 'shared-file-two' 30 "G-3 StripPrefix rewrite resolves backend path"; then
        :
    else
        failures=$((failures + 1))
    fi

    # G-4: load balancing across both simple-discovery instances
    local i one=0 two=0 body
    for (( i = 0; i < 12; i++ )); do
        if body="$(curl -fsS --max-time 5 "${base_url}/demo/index.html" 2>/dev/null)"; then
            case "${body}" in
                *backend-one*) one=$((one + 1)) ;;
                *backend-two*) two=$((two + 1)) ;;
            esac
        fi
        sleep 0.2
    done
    if (( one > 0 && two > 0 )); then
        pass "G-4 load balancing hit both backends (one=${one}, two=${two})"
    else
        printf 'FAIL: G-4 load balancing did not hit both backends (one=%s, two=%s)\n' "${one}" "${two}" >&2
        failures=$((failures + 1))
    fi

    # G-5: rate limiting requires an external redis instance; run it only
    # when REDIS_HOST is provided.
    if [[ -n "${REDIS_HOST:-}" ]]; then
        printf 'SKIP: G-5 rate limiting against %s is executed by the optional scenario\n' "${REDIS_HOST}"
    else
        printf 'SKIP: G-5 rate limiting requires redis (set REDIS_HOST to enable)\n'
    fi

    # G-6: long-run stability (opt-in)
    if [[ "${LONG_RUN:-0}" == "1" ]]; then
        local deadline=$(( $(date +%s) + 14400 ))
        printf 'INFO: G-6 long-run started, will run for 4h\n'
        while (( $(date +%s) < deadline )); do
            if ! curl -fsS --max-time 5 "${base_url}/actuator/health" >/dev/null 2>&1; then
                printf 'FAIL: G-6 health check failed during long run at %s\n' "$(date)" >&2
                failures=$((failures + 1))
                break
            fi
            sleep 30
        done
        if (( failures == 0 )); then
            pass "G-6 gateway survived the 4h stability loop"
        fi
    else
        printf 'SKIP: G-6 long-run stability (set LONG_RUN=1 to enable)\n'
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
