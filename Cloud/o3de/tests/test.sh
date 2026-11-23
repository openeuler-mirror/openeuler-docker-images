#!/bin/bash

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

O3DE_ROOT="/o3de"
O3DE_SH="${O3DE_ROOT}/scripts/o3de.sh"
WORKDIR=""

cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_version() {
    local probs tag

    if [ ! -d "${O3DE_ROOT}/.git" ]; then
        printf 'FAIL: %s is not a git repository\n' "${O3DE_ROOT}"
        return 1
    fi

    probs="$(
        git -C "${O3DE_ROOT}" tag --points-at HEAD 2>/dev/null || true
        git -C "${O3DE_ROOT}" describe --tags --exact-match HEAD 2>/dev/null || true
    )"
    while IFS= read -r tag; do
        [ -n "${tag}" ] || continue
        if [ "${tag}" = "${EXPECTED_VERSION}" ]; then
            printf 'PASS: o3de release tag exactly %s\n' "${tag}"
            return 0
        fi
    done <<< "${probs}"
    printf 'FAIL: expected o3de release tag %s at HEAD, got: %s\n' \
        "${EXPECTED_VERSION}" "$(printf '%s' "${probs}" | tr '\n' ' ' | cut -c1-300)"
    return 1
}

test_cli_sha256() {
    local out digest expected file

    if [ ! -x "${O3DE_SH}" ]; then
        printf 'FAIL: o3de CLI launcher missing at %s\n' "${O3DE_SH}"
        return 1
    fi

    WORKDIR="$(mktemp -d)" || {
        printf 'FAIL: could not create temporary directory\n'
        return 1
    }
    file="${WORKDIR}/probe.txt"
    printf 'o3de-kunpeng-ci-probe\n' > "${file}"
    expected="$(sha256sum "${file}")"
    expected="${expected%% *}"

    out="$( "${O3DE_SH}" sha256 --file-path "${file}" 2>"${WORKDIR}/cli.err" || true )"
    digest="$(printf '%s' "${out}" | grep -Eo '[0-9a-f]{64}' | tail -n 1)"

    if [ -n "${digest}" ] && [ "${digest}" = "${expected}" ]; then
        printf 'PASS: o3de CLI sha256 matched sha256sum (%s)\n' "${digest}"
        return 0
    fi
    printf 'FAIL: o3de CLI sha256 mismatch expected=%s got=%s (err: %s)\n' \
        "${expected}" "${digest}" "$(tr '\n' ' ' < "${WORKDIR}/cli.err" | cut -c1-200)"
    return 1
}

test_engine_source() {
    if [ ! -f "${O3DE_ROOT}/engine.json" ]; then
        printf 'FAIL: engine.json missing at %s\n' "${O3DE_ROOT}"
        return 1
    fi
    if ! grep -Eq '"engine_name"[[:space:]]*:[[:space:]]*"o3de"' "${O3DE_ROOT}/engine.json"; then
        printf 'FAIL: engine.json engine_name is not "o3de"\n'
        return 1
    fi
    if [ ! -f "${O3DE_ROOT}/build/linux/CMakeCache.txt" ]; then
        printf 'FAIL: build/linux/CMakeCache.txt missing (cmake configure did not complete)\n'
        return 1
    fi
    if ! grep -Eq 'CMAKE_GENERATOR:INTERNAL=Ninja Multi-Config' "${O3DE_ROOT}/build/linux/CMakeCache.txt"; then
        printf 'FAIL: CMakeCache does not reference "Ninja Multi-Config" generator\n'
        return 1
    fi
    printf 'PASS: engine.json and configured build tree present\n'
    return 0
}

test_editor_binary() {
    local editor="${O3DE_ROOT}/build/linux/bin/release/Editor"

    if [ ! -x "${editor}" ]; then
        printf 'FAIL: Editor binary missing at %s\n' "${editor}"
        return 1
    fi
    if ldd "${editor}" 2>/dev/null | grep -q 'not found'; then
        printf 'FAIL: Editor has unresolved shared libraries:\n%s\n' \
            "$(ldd "${editor}" 2>/dev/null | grep 'not found' | head -n 10)"
        return 1
    fi
    if ! ldd "${editor}" 2>/dev/null | grep -q 'libQt6Core'; then
        printf 'FAIL: Editor is not linked against Qt6 (libQt6Core absent)\n'
        return 1
    fi
    printf 'PASS: Editor binary present, all shared libraries resolved, Qt6 linked\n'
    return 0
}

main() {
    local failures=0

    test_version       || failures=$((failures + 1))
    test_cli_sha256    || failures=$((failures + 1))
    test_engine_source || failures=$((failures + 1))
    test_editor_binary || failures=$((failures + 1))

    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"