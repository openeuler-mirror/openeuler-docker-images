#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

LUA="/usr/local/bin/lua"
WORKDIR=""

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_binary_present() {
    if [[ ! -x "${LUA}" ]]; then
        printf 'FAIL: lua interpreter not found or not executable: %s\n' "${LUA}" >&2
        return 1
    fi
    printf 'PASS: lua interpreter present: %s\n' "${LUA}"
}

test_version() {
    local output reported rc

    if ! output="$("${LUA}" -v 2>&1)"; then
        rc=$?
        printf 'FAIL: lua -v exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ ! "${output}" =~ ^Lua[[:space:]]+([0-9]+\.[0-9]+\.[0-9]+)([[:space:]]|$) ]]; then
        printf 'FAIL: cannot parse version from lua -v output: <%s>\n' "${output}" >&2
        return 1
    fi
    reported="${BASH_REMATCH[1]}"

    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${reported}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${reported}"
}

test_inline_execution() {
    local output rc expected="5050"

    if ! output="$("${LUA}" -e 'local acc = 0; for i = 1, 100 do acc = acc + i end; print(acc)' 2>&1)"; then
        rc=$?
        printf 'FAIL: lua -e exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: inline chunk result mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    printf 'PASS: inline chunk execution (-e): %s\n' "${output}"
}

test_script_execution() {
    local script="${WORKDIR}/wordcount.lua"
    local data="${WORKDIR}/words.txt"
    local output rc
    local expected="brown=1,dog=1,fox=2,jumps=1,lazy=1,over=1,quick=1,the=3"

    cat > "${script}" <<'LUA'
local path = arg[1]
local f = assert(io.open(path, "r"))
local counts = {}
for line in f:lines() do
  for word in line:gmatch("%a+") do
    counts[word] = (counts[word] or 0) + 1
  end
end
f:close()
local keys = {}
for k in pairs(counts) do keys[#keys + 1] = k end
table.sort(keys)
local parts = {}
for _, k in ipairs(keys) do
  parts[#parts + 1] = k .. "=" .. counts[k]
end
print(table.concat(parts, ","))
LUA

    cat > "${data}" <<'DATA'
the quick brown fox
jumps over the lazy dog the fox
DATA

    if ! output="$("${LUA}" "${script}" "${data}" 2>&1)"; then
        rc=$?
        printf 'FAIL: lua script exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: script result mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    printf 'PASS: script execution with arg table and io/string/table libraries: %s\n' "${output}"
}

main() {
    local failures=0

    WORKDIR="$(mktemp -d)"
    if [[ ! -d "${WORKDIR}" ]]; then
        printf 'FAIL: cannot create temporary working directory\n' >&2
        return 1
    fi

    if ! test_binary_present; then
        failures=$((failures + 1))
    fi
    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_inline_execution; then
        failures=$((failures + 1))
    fi
    if ! test_script_execution; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
