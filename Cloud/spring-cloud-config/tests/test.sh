#!/bin/bash
set -euo pipefail

# Functional tests for the openeuler/spring-cloud-config image.
# Covers: startup/health, version, git backend, wire contract, git refresh,
# native backend, encrypt/decrypt.
#
# Required env:
#   EXPECTED_VERSION   config component version the image was built for (e.g. 5.0.6)
# Optional env:
#   IMAGE              image ref (default openeuler/spring-cloud-config:${EXPECTED_VERSION}-oe2403sp4)
#   GIT_PORT           host port for the git/native-backed server (default 18888)
#   ENC_PORT           host port for the encrypt/decrypt server (default 18889)

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

IMAGE="${IMAGE:-openeuler/spring-cloud-config:${EXPECTED_VERSION}-oe2403sp4}"
GIT_PORT="${GIT_PORT:-18888}"
ENC_PORT="${ENC_PORT:-18889}"

WORKDIR=""
SVC_CID=""
ENC_CID=""

cleanup() {
    for cid in "${SVC_CID:-}" "${ENC_CID:-}"; do
        if [[ -n "${cid}" ]]; then
            docker rm -f "${cid}" >/dev/null 2>&1 || true
        fi
    done
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

git_commit_file() {
    local path="$1" content="$2" msg="$3"
    printf '%s\n' "${content}" > "${path}"
    git -C "$(dirname "${path}")" add "$(basename "${path}")" >/dev/null
    git -C "$(dirname "${path}")" commit -q -m "${msg}" >/dev/null
}

main() {
    for tool in docker curl mktemp; do
        if ! command -v "${tool}" >/dev/null 2>&1; then
            printf 'FAIL: required tool missing on host: %s\n' "${tool}" >&2
            exit 1
        fi
    done

    WORKDIR="$(mktemp -d)"
    mkdir -p "${WORKDIR}/gitrepo" "${WORKDIR}/native-repo"

    local failures=0
    local git_url=""

    # ---------- C-3: native backend (no git dependency, start first) ----------
    printf 'demo:\n  message: native-hello\n' > "${WORKDIR}/native-repo/application.yml"

    docker run -d --name sccfg-native \
        -p "${GIT_PORT}:8888" \
        -e SPRING_PROFILES_ACTIVE=native \
        -e SPRING_CLOUD_CONFIG_SERVER_NATIVE_SEARCHLOCATIONS="file:/native-repo" \
        -v "${WORKDIR}/native-repo:/native-repo:ro" \
        "${IMAGE}" >/dev/null
    SVC_CID="sccfg-native"

    local native_url="http://127.0.0.1:${GIT_PORT}"

    if poll_http "${native_url}/actuator/health" '"UP"' 180 "C-1 config-server starts and reports health UP"; then
        :
    else
        failures=$((failures + 1))
        docker logs --tail 50 sccfg-native 2>&1 || true
    fi

    local ver
    if ver="$(docker exec sccfg-native cat /app/IMAGE_VERSION 2>/dev/null)"; then
        if [[ "${ver}" == *" ${EXPECTED_VERSION} "* ]]; then
            pass "C-1 image version matches expectation: ${ver}"
        else
            printf 'FAIL: C-1 version mismatch: expected %s in <%s>\n' "${EXPECTED_VERSION}" "${ver}" >&2
            failures=$((failures + 1))
        fi
    else
        printf 'FAIL: C-1 cannot read /app/IMAGE_VERSION\n' >&2
        failures=$((failures + 1))
    fi

    if poll_http "${native_url}/application/default" 'native-hello' 30 "C-3 native backend serves mounted config"; then
        :
    else
        failures=$((failures + 1))
    fi

    # ---------- C-4: client wire contract (against native server) ----------
    local contract contract_compact
    if contract="$(curl -fsS --max-time 5 "${native_url}/application/default" 2>/dev/null)"; then
        contract_compact="${contract// /}"
        if [[ "${contract_compact}" == *'"propertySources"'* && "${contract_compact}" == *'"name":"application"'* ]]; then
            pass "C-4 response matches the config-client wire contract"
        else
            printf 'FAIL: C-4 wire contract mismatch, body: %s\n' "${contract:0:300}" >&2
            failures=$((failures + 1))
        fi
    else
        printf 'FAIL: C-4 could not fetch config response\n' >&2
        failures=$((failures + 1))
    fi

    # stop the native server to free the port for the git-backed one
    docker rm -f sccfg-native >/dev/null 2>&1 || true
    SVC_CID=""

    # ---------- C-2 + C-5: git backend and refresh ----------
    if command -v git >/dev/null 2>&1; then
        git init -q -b main "${WORKDIR}/gitrepo"
        git -C "${WORKDIR}/gitrepo" config user.email test@openeuler.org
        git -C "${WORKDIR}/gitrepo" config user.name openeuler-test
        git_commit_file "${WORKDIR}/gitrepo/application.yml" 'demo:
  message: git-hello-v1' "v1"

        docker run -d --name sccfg-git \
            -p "${GIT_PORT}:8888" \
            -e SPRING_CLOUD_CONFIG_SERVER_GIT_URI="file:///gitrepo" \
            -v "${WORKDIR}/gitrepo:/gitrepo" \
            "${IMAGE}" >/dev/null
        SVC_CID="sccfg-git"

        if poll_http "${native_url}/application/default" 'git-hello-v1' 180 "C-2 git backend serves committed config"; then
            :
        else
            failures=$((failures + 1))
            docker logs --tail 50 sccfg-git 2>&1 || true
        fi

        # C-5: commit a new revision, the server must pick it up on the next request
        git_commit_file "${WORKDIR}/gitrepo/application.yml" 'demo:
  message: git-hello-v2' "v2"
        if poll_http "${native_url}/application/default" 'git-hello-v2' 60 "C-5 server serves refreshed git revision"; then
            :
        else
            failures=$((failures + 1))
        fi
        git_url="file:///gitrepo"
    else
        printf 'SKIP: C-2/C-5 git backend requires git on the host\n'
    fi

    # ---------- C-6: encrypt/decrypt with a symmetric key ----------
    docker run -d --name sccfg-enc \
        -p "${ENC_PORT}:8888" \
        -e SPRING_PROFILES_ACTIVE=native \
        -e SPRING_CLOUD_CONFIG_SERVER_NATIVE_SEARCHLOCATIONS=file:/app/config \
        -e ENCRYPT_KEY="openeuler-sckunpeng-test-key" \
        "${IMAGE}" >/dev/null
    ENC_CID="sccfg-enc"

    local enc_url="http://127.0.0.1:${ENC_PORT}"
    if poll_http "${enc_url}/actuator/health" '"UP"' 180 "C-6 encrypt server healthy"; then
        local cipher plain
        if cipher="$(curl -fsS --max-time 10 --data-binary 'kunpeng-openEuler' -H 'Content-Type: text/plain' "${enc_url}/encrypt" 2>/dev/null)" \
            && [[ -n "${cipher}" ]]; then
            pass "C-6 /encrypt produced ciphertext"
            if plain="$(curl -fsS --max-time 10 --data-binary "${cipher}" -H 'Content-Type: text/plain' "${enc_url}/decrypt" 2>/dev/null)" \
                && [[ "${plain}" == "kunpeng-openEuler" ]]; then
                pass "C-6 /decrypt restored the original plaintext"
            else
                printf 'FAIL: C-6 decrypt mismatch: <%s>\n' "${plain}" >&2
                failures=$((failures + 1))
            fi
        else
            printf 'FAIL: C-6 /encrypt returned empty response\n' >&2
            failures=$((failures + 1))
        fi
    else
        failures=$((failures + 1))
        docker logs --tail 50 sccfg-enc 2>&1 || true
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
