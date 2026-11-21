#!/bin/bash
# KunpengTest functional test for milvus (standalone vector database).
#
# CI runs this file inside the image under test with --entrypoint bash and the
# script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION, DOCKER_NAMESPACE, DOCKER_PACKAGE, DOCKER_TAG, DOCKER_IMAGE.
#
# Milvus standalone needs etcd (metadata) and MinIO (object storage) running
# first, so this script launches the three processes documented in the image
# README, then asserts (a) the exact version reported by the startup banner and
# (b) that the Milvus HTTP health probe /healthz answers "OK".

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

WORKDIR=""
ETCD_PID=""
MINIO_PID=""
MILVUS_PID=""
MILVUS_LOG=""
_STARTED=0

ETCD_TRIES=30
MINIO_TRIES=30
MILVUS_TRIES=90
VERSION_TRIES=30

cleanup() {
    [ -n "${MILVUS_PID}" ] && kill "${MILVUS_PID}" 2>/dev/null
    [ -n "${MINIO_PID}" ] && kill "${MINIO_PID}" 2>/dev/null
    [ -n "${ETCD_PID}" ] && kill "${ETCD_PID}" 2>/dev/null
    sleep 1
    [ -n "${MILVUS_PID}" ] && kill -9 "${MILVUS_PID}" 2>/dev/null
    [ -n "${MINIO_PID}" ] && kill -9 "${MINIO_PID}" 2>/dev/null
    [ -n "${ETCD_PID}" ] && kill -9 "${ETCD_PID}" 2>/dev/null
    [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ] && rm -rf "${WORKDIR}"
}
trap cleanup EXIT

# wait_tcp returns 0 as soon as a TCP connection to host:port succeeds, giving
# up after $tries one-second attempts. /dev/tcp fails fast (connection refused)
# on a localhost port that is not yet listening.
wait_tcp() {
    local host="$1" port="$2" tries="$3" i=0
    while [ "${i}" -lt "${tries}" ]; do
        if (exec 3<>"/dev/tcp/${host}/${port}") 2>/dev/null; then
            return 0
        fi
        i=$((i + 1))
        sleep 1
    done
    return 1
}

# healthz_body issues "GET /healthz" against the Milvus management/metrics port
# (default 9091) and echoes the response body. When the standalone cluster is
# fully healthy the body is exactly "OK".
healthz_body() {
    local resp
    exec 3<>"/dev/tcp/127.0.0.1/9091" 2>/dev/null || return 1
    printf 'GET /healthz HTTP/1.1\r\nHost: 127.0.0.1\r\nConnection: close\r\n\r\n' >&3
    resp="$(cat <&3 2>/dev/null || true)"
    exec 3<&- 2>/dev/null
    exec 3>&- 2>/dev/null
    printf '%s' "${resp}"
    return 0
}

extract_version() {
    local line v
    while IFS= read -r line; do
        case "${line}" in
            Version:*)
                v="${line#Version:}"
                v="${v#"${v%%[![:space:]]*}"}"
                v="${v%"${v##*[![:space:]]}"}"
                printf '%s\n' "${v}"
                return 0
                ;;
        esac
    done < "${MILVUS_LOG}"
    return 1
}

# start_stack launches etcd, MinIO and Milvus standalone once, waiting for the
# two dependencies to accept connections before Milvus is started. Idempotent:
# subsequent calls reuse the already-running processes.
start_stack() {
    if [ "${_STARTED}" = "1" ]; then
        return 0
    fi
    for cmd in milvus etcd minio; do
        if ! command -v "${cmd}" >/dev/null 2>&1; then
            return 1
        fi
    done

    WORKDIR="$(mktemp -d)" || return 1
    MILVUS_LOG="${WORKDIR}/milvus.log"

    etcd --data-dir="${WORKDIR}/etcd" >"${WORKDIR}/etcd.log" 2>&1 &
    ETCD_PID=$!
    if ! wait_tcp 127.0.0.1 2379 "${ETCD_TRIES}"; then
        return 1
    fi

    MINIO_ROOT_USER=minioadmin MINIO_ROOT_PASSWORD=minioadmin \
        minio server "${WORKDIR}/minio-data" >"${WORKDIR}/minio.log" 2>&1 &
    MINIO_PID=$!
    if ! wait_tcp 127.0.0.1 9000 "${MINIO_TRIES}"; then
        return 1
    fi

    export MILVUSCONF=/milvus/configs
    milvus run standalone >"${MILVUS_LOG}" 2>&1 &
    MILVUS_PID=$!

    _STARTED=1
    return 0
}

test_version() {
    local v i=0
    if ! start_stack; then
        printf 'FATAL: unable to start milvus standalone stack\n'
        return 1
    fi
    v=""
    while [ "${i}" -lt "${VERSION_TRIES}" ]; do
        v="$(extract_version 2>/dev/null || true)"
        [ -n "${v}" ] && break
        i=$((i + 1))
        sleep 1
    done
    if [ -z "${v}" ]; then
        printf 'FAIL: no Version line found in milvus startup banner\n'
        return 1
    fi
    v="${v#v}"
    v="${v#V}"
    if [ "${v}" = "${EXPECTED_VERSION}" ]; then
        printf 'PASS: milvus reports version %s\n' "${v}"
        return 0
    fi
    printf 'FAIL: expected version %s, got %s\n' "${EXPECTED_VERSION}" "${v}"
    return 1
}

test_standalone_health() {
    local resp body i=0
    if ! start_stack; then
        printf 'FATAL: unable to start milvus standalone stack\n'
        return 1
    fi
    body=""
    while [ "${i}" -lt "${MILVUS_TRIES}" ]; do
        resp="$(healthz_body 2>/dev/null || true)"
        body="${resp#*$'\r\n\r\n'}"
        [ "${body}" = "OK" ] && break
        i=$((i + 1))
        sleep 1
    done
    if [ "${body}" = "OK" ]; then
        printf 'PASS: milvus standalone health probe /healthz returned OK\n'
        return 0
    fi
    printf 'FAIL: milvus /healthz not OK (got: %s)\n' \
        "$(printf '%s' "${body}" | tr -c '[:print:]' ' ' | cut -c1-120)"
    return 1
}

main() {
    local failures=0
    test_version          || failures=$((failures + 1))
    test_standalone_health || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"
