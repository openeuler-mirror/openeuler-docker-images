#!/bin/bash

EXPECTED_VERSION="${EXPECTED_VERSION:?EXPECTED_VERSION is required}"
DRUID_HOME="/opt/druid"
DRUID_CLI_TIMEOUT="${DRUID_CLI_TIMEOUT:-120}"
WORKDIR=""

cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

run_druid_cli() {
    local outfile="$1"; shift
    local i pid
    ( cd "${DRUID_HOME}" >/dev/null 2>&1 && exec java -cp 'lib/*' org.apache.druid.cli.Main "$@" ) >"${outfile}" 2>&1 &
    pid=$!
    for ((i = 1; i <= DRUID_CLI_TIMEOUT; i++)); do
        if ! kill -0 "${pid}" 2>/dev/null; then
            break
        fi
        sleep 1
    done
    if kill -0 "${pid}" 2>/dev/null; then
        kill "${pid}" 2>/dev/null || true
        wait "${pid}" 2>/dev/null || true
        return 124
    fi
    wait "${pid}"
    return $?
}

test_version() {
    local outfile reported
    outfile="${WORKDIR}/version.out"
    if ! run_druid_cli "${outfile}" version; then
        echo "FAIL: 'druid version' command failed - $(tr '\n' ' ' < "${outfile}" 2>/dev/null | cut -c1-200)"
        return 1
    fi
    reported="$(grep -E '^Druid version - ' "${outfile}" 2>/dev/null | head -n1 | sed -E 's/^Druid version - //; s/[[:space:]]+$//')"
    if [ "${reported}" = "${EXPECTED_VERSION}" ]; then
        echo "PASS: exact Druid version ${reported}"
        return 0
    fi
    echo "FAIL: expected 'Druid version - ${EXPECTED_VERSION}', got '${reported}'"
    return 1
}

test_validate_query() {
    local outfile spec
    spec="${WORKDIR}/valid-query.json"
    cat > "${spec}" <<'JSON'
{
  "queryType": "timeseries",
  "dataSource": "wikipedia",
  "intervals": ["2015-09-12/2015-09-13"],
  "granularity": "all",
  "aggregations": [{ "type": "count", "name": "count" }]
}
JSON
    outfile="${WORKDIR}/validate-query.out"
    if run_druid_cli "${outfile}" tools validator -f "${spec}" -t query; then
        echo "PASS: Druid validator accepted a valid timeseries query"
        return 0
    fi
    echo "FAIL: Druid validator rejected a valid query - $(tr '\n' ' ' < "${outfile}" 2>/dev/null | cut -c1-300)"
    return 1
}

test_validate_reject() {
    local outfile spec
    spec="${WORKDIR}/invalid-query.json"
    cat > "${spec}" <<'JSON'
{
  "queryType": "noSuchQueryType",
  "dataSource": "wikipedia"
}
JSON
    outfile="${WORKDIR}/validate-invalid.out"
    if run_druid_cli "${outfile}" tools validator -f "${spec}" -t query; then
        echo "FAIL: Druid validator accepted an invalid query (exit 0)"
        return 1
    fi
    echo "PASS: Druid validator rejected an invalid query"
    return 0
}

main() {
    local failures=0
    WORKDIR="$(mktemp -d)" || { echo "FATAL: cannot create temp dir"; return 1; }
    test_version         || failures=$((failures + 1))
    test_validate_query  || failures=$((failures + 1))
    test_validate_reject || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        return 0
    fi
    echo "TESTS_FAILED: ${failures} failure(s)"
    return 1
}

main "$@"
