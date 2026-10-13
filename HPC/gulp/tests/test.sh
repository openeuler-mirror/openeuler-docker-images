#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# gulp CLI installed globally by npm with --prefix /opt/gulp (see Dockerfile:
# npm install --global --prefix /opt/gulp gulp@${VERSION} and ENV PATH=/opt/gulp/bin).
GULP_BIN="/opt/gulp/bin/gulp"

if [[ ! -x "${GULP_BIN}" ]]; then
    printf 'FATAL: gulp CLI not executable at %s\n' "${GULP_BIN}" >&2
    exit 1
fi

# Derive the global node_modules root from the CLI binary so a project (or a
# task gulpfile) can resolve the globally installed gulp package.
GULP_REAL="$(readlink -f "${GULP_BIN}")"
GULP_PKG_DIR="$(dirname "$(dirname "${GULP_REAL}")")"
GLOBAL_MODULES="$(dirname "${GULP_PKG_DIR}")"

if [[ ! -f "${GLOBAL_MODULES}/gulp/package.json" ]]; then
    printf 'FATAL: gulp package not found under %s\n' "${GLOBAL_MODULES}" >&2
    exit 1
fi

TEST_DIR=""
cleanup() {
    if [[ -n "${TEST_DIR}" && -d "${TEST_DIR}" ]]; then
        rm -rf "${TEST_DIR}"
    fi
}
trap cleanup EXIT

run_gulp() {
    NODE_PATH="${GLOBAL_MODULES}" "${GULP_BIN}" "$@"
}

# `gulp --version` displays the CLI version and the local gulp version.
# With the global gulp resolvable the reported local version is the installed
# gulp release, so it must equal EXPECTED_VERSION exactly.
test_version() {
    local output rc cli_version="" local_version="" line

    if output="$(run_gulp --version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: "gulp --version" exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    while IFS= read -r line; do
        case "${line}" in
            "CLI version:"*) cli_version="${line#CLI version: }" ;;
            "Local version:"*) local_version="${line#Local version: }" ;;
        esac
    done <<< "${output}"

    if [[ -z "${cli_version}" ]]; then
        printf 'FAIL: gulp CLI did not report its version; output=<%s>\n' "${output}" >&2
        return 1
    fi

    if [[ "${local_version}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: gulp version mismatch: expected=<%s> actual=<%s> full=<%s>\n' \
            "${EXPECTED_VERSION}" "${local_version}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact gulp version reported by CLI: %s\n' "${local_version}"
}

# Run a real gulp task: `gulp <task>` executes an exported gulpfile task, and
# the task uses the src()/dest() file pipeline to copy a known file.
test_core_function() {
    local output rc result

    TEST_DIR="$(mktemp -d)"
    printf 'gulp-smoke-payload\n' > "${TEST_DIR}/input.txt"

    cat > "${TEST_DIR}/gulpfile.js" <<'JS'
'use strict';
const { src, dest } = require('gulp');

function copy() {
  return src('input.txt').pipe(dest('output'));
}

exports.copy = copy;
JS

    if output="$(cd "${TEST_DIR}" && run_gulp copy 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: "gulp copy" exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ ! -f "${TEST_DIR}/output/input.txt" ]]; then
        printf 'FAIL: gulp task did not write output/input.txt; output=<%s>\n' "${output}" >&2
        return 1
    fi

    result="$(< "${TEST_DIR}/output/input.txt")"
    if [[ "${result}" != "gulp-smoke-payload" ]]; then
        printf 'FAIL: gulp copy produced wrong content: <%s>\n' "${result}" >&2
        return 1
    fi

    printf 'PASS: gulp executed exported task and copied file via src()/dest()\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_core_function; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
