#!/bin/bash

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

ALERTMANAGER_BIN="/bin/alertmanager"
AMTOOL_BIN="/bin/amtool"
WORKDIR=""
SERVER_PID=""

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

extract_version() {
    local line="$1" rest
    rest="${line#* version }"
    if [ "${rest}" = "${line}" ]; then
        return 1
    fi
    printf '%s' "${rest%% *}"
}

test_version() {
    local output first reported

    if [ ! -x "${ALERTMANAGER_BIN}" ]; then
        printf 'FAIL: alertmanager binary not executable at %s\n' "${ALERTMANAGER_BIN}" >&2
        return 1
    fi

    output="$("${ALERTMANAGER_BIN}" --version 2>&1 || true)"
    first="${output%%$'\n'*}"
    if [[ "${first}" != "alertmanager, version "* ]]; then
        printf 'FAIL: unexpected alertmanager version output: <%s>\n' "${first}" >&2
        return 1
    fi

    reported="$(extract_version "${first}")" || {
        printf 'FAIL: could not parse version from <%s>\n' "${first}" >&2
        return 1
    }
    if [ "${reported}" != "${EXPECTED_VERSION}" ]; then
        printf 'FAIL: alertmanager version mismatch: expected=<%s> actual=<%s>\n' "${EXPECTED_VERSION}" "${reported}" >&2
        return 1
    fi

    printf 'PASS: alertmanager version exactly %s\n' "${reported}"
}

test_amtool_version() {
    local output first reported

    if [ ! -x "${AMTOOL_BIN}" ]; then
        printf 'FAIL: amtool binary not executable at %s\n' "${AMTOOL_BIN}" >&2
        return 1
    fi

    output="$("${AMTOOL_BIN}" --version 2>&1 || true)"
    first="${output%%$'\n'*}"
    if [[ "${first}" != "amtool, version "* ]]; then
        printf 'FAIL: unexpected amtool version output: <%s>\n' "${first}" >&2
        return 1
    fi

    reported="$(extract_version "${first}")" || {
        printf 'FAIL: could not parse amtool version from <%s>\n' "${first}" >&2
        return 1
    }
    if [ "${reported}" != "${EXPECTED_VERSION}" ]; then
        printf 'FAIL: amtool version mismatch: expected=<%s> actual=<%s>\n' "${EXPECTED_VERSION}" "${reported}" >&2
        return 1
    fi

    printf 'PASS: amtool version exactly %s\n' "${reported}"
}

test_service() {
    local i body status version

    if ! command -v wget >/dev/null 2>&1; then
        printf 'FAIL: wget is not available for the HTTP probe\n' >&2
        return 1
    fi

    WORKDIR="$(mktemp -d)" || {
        printf 'FAIL: could not create a temporary directory\n' >&2
        return 1
    }

    "${ALERTMANAGER_BIN}" \
        --config.file=/etc/alertmanager/alertmanager.yml \
        --storage.path=/alertmanager \
        >"${WORKDIR}/alertmanager.log" 2>&1 &
    SERVER_PID=$!

    body=""
    for (( i = 0; i < 30; i++ )); do
        if body="$(wget -q -O - http://127.0.0.1:9093/-/healthy 2>/dev/null)" && [ "${body}" = "OK" ]; then
            break
        fi
        sleep 1
    done
    if [ "${body}" != "OK" ]; then
        printf 'FAIL: alertmanager did not become healthy on 127.0.0.1:9093 within 30s\n' >&2
        return 1
    fi

    status="$(wget -q -O - http://127.0.0.1:9093/api/v2/status 2>/dev/null || true)"
    version="${status#*\"version\":\"}"
    if [ "${version}" = "${status}" ]; then
        printf 'FAIL: /api/v2/status did not report a versionInfo.version\n' >&2
        return 1
    fi
    version="${version%%\"*}"
    if [ "${version}" != "${EXPECTED_VERSION}" ]; then
        printf 'FAIL: /api/v2/status version mismatch: expected=<%s> actual=<%s>\n' "${EXPECTED_VERSION}" "${version}" >&2
        return 1
    fi

    printf 'PASS: alertmanager served /api/v2/status with version %s\n' "${version}"
}

main() {
    local failures=0

    test_version || failures=$((failures + 1))
    test_amtool_version || failures=$((failures + 1))
    test_service || failures=$((failures + 1))

    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
    return 1
}

main "$@"
