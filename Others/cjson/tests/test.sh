#!/bin/bash
# KunpengTest functional test for cjson.
#
# cJSON is a lightweight single-header C JSON parsing/generation library. The
# image installs the shared library (libcjson.so), the public header
# (/usr/include/cjson/cJSON.h) and keeps a C compiler (gcc-c++) available, but
# ships no standalone CLI binary. We therefore compile tiny C programs against
# the installed library/header to (1) assert the exact version reported by
# cJSON_Version() and (2) exercise the real parse/print round-trip data path.
#
# CI runs this file inside the image under test with --entrypoint bash and the
# script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION, DOCKER_NAMESPACE, DOCKER_PACKAGE, DOCKER_TAG, DOCKER_IMAGE.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

WORKDIR=""
CC=""

cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
        WORKDIR=""
    fi
}
trap cleanup EXIT

find_cc() {
    if command -v gcc >/dev/null 2>&1; then
        CC="gcc"
        return 0
    fi
    if command -v cc >/dev/null 2>&1; then
        CC="cc"
        return 0
    fi
    return 1
}

# Compile $1 (C source) into $2 (binary) against the installed libcjson.
# Compiler diagnostics are captured and printed only on failure.
compile_probe() {
    local src="$1" bin="$2" errfile="${WORKDIR}/compile.err"
    if ! "${CC}" "${src}" -lcjson -o "${bin}" 2>"${errfile}"; then
        printf 'FAIL: failed to compile %s: %s\n' \
            "$(basename "${src}")" "$(cat "${errfile}")"
        return 1
    fi
    return 0
}

test_version() {
    local src bin out
    if [ -z "${CC}" ]; then
        printf 'FATAL: no C compiler (gcc/cc) found in image\n'
        return 1
    fi
    src="${WORKDIR}/version.c"
    bin="${WORKDIR}/version_probe"
    cat > "${src}" <<'EOF'
#include <stdio.h>
#include <cjson/cJSON.h>

int main(void)
{
    printf("%s\n", cJSON_Version());
    return 0;
}
EOF
    if ! compile_probe "${src}" "${bin}"; then
        return 1
    fi
    out="$("${bin}" 2>&1 || true)"
    if [ "${out}" = "${EXPECTED_VERSION}" ]; then
        printf 'PASS: exact cJSON version %s\n' "${out}"
        return 0
    fi
    printf 'FAIL: expected cJSON version %s, got %s\n' \
        "${EXPECTED_VERSION}" "${out}"
    return 1
}

test_core_function() {
    local src bin out rc
    if [ -z "${CC}" ]; then
        printf 'FATAL: no C compiler (gcc/cc) found in image\n'
        return 1
    fi
    src="${WORKDIR}/roundtrip.c"
    bin="${WORKDIR}/roundtrip_probe"
    cat > "${src}" <<'EOF'
#include <stdio.h>
#include <string.h>
#include <cjson/cJSON.h>

int main(void)
{
    cJSON *root = cJSON_CreateObject();
    cJSON *parsed = NULL;
    cJSON *item = NULL;
    char *json_str = NULL;
    const char *name = NULL;
    double age = 0.0;
    int ok = 0;

    if (root == NULL) { return 10; }
    if (!cJSON_AddStringToObject(root, "name", "Alice")) { cJSON_Delete(root); return 11; }
    if (!cJSON_AddNumberToObject(root, "age", 25)) { cJSON_Delete(root); return 12; }

    json_str = cJSON_PrintUnformatted(root);
    if (json_str == NULL) { cJSON_Delete(root); return 13; }

    parsed = cJSON_Parse(json_str);
    if (parsed == NULL) { cJSON_free(json_str); cJSON_Delete(root); return 14; }

    item = cJSON_GetObjectItemCaseSensitive(parsed, "name");
    if (item != NULL) { name = cJSON_GetStringValue(item); }

    item = cJSON_GetObjectItemCaseSensitive(parsed, "age");
    if (item != NULL) { age = cJSON_GetNumberValue(item); }

    printf("%s\n", json_str);
    printf("name=%s\n", name != NULL ? name : "(null)");
    printf("age=%.0f\n", age);

    if (name != NULL && strcmp(name, "Alice") == 0 && age == 25.0) {
        ok = 1;
    }

    cJSON_Delete(parsed);
    cJSON_free(json_str);
    cJSON_Delete(root);

    return ok ? 0 : 15;
}
EOF
    if ! compile_probe "${src}" "${bin}"; then
        return 1
    fi
    out="$("${bin}" 2>&1)"
    rc=$?
    if [ "${rc}" -ne 0 ]; then
        printf 'FAIL: round-trip probe exited %s: %s\n' "${rc}" "${out}"
        return 1
    fi
    if [[ "${out}" != *'"name":"Alice"'* ]]; then
        printf 'FAIL: generated JSON missing string field: %s\n' "${out}"
        return 1
    fi
    if [[ "${out}" != *'"age":25'* ]]; then
        printf 'FAIL: generated JSON missing number field: %s\n' "${out}"
        return 1
    fi
    if [[ "${out}" != *'name=Alice'* ]]; then
        printf 'FAIL: parsed string mismatch: %s\n' "${out}"
        return 1
    fi
    if [[ "${out}" != *'age=25'* ]]; then
        printf 'FAIL: parsed number mismatch: %s\n' "${out}"
        return 1
    fi
    printf 'PASS: JSON create/print/parse round-trip data path\n'
    return 0
}

main() {
    local failures=0
    if ! find_cc; then
        printf 'FATAL: no C compiler (gcc/cc) found in image\n'
        return 1
    fi
    WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/cjson-test.XXXXXX")"

    test_version || failures=$((failures + 1))
    test_core_function || failures=$((failures + 1))

    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"