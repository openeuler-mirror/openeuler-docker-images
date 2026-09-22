#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

JEMALLOC_CONFIG="/usr/local/bin/jemalloc-config"
INCLUDE_DIR="/usr/local/include"
LIB_DIR="/usr/local/lib"
WORKDIR=""

# jemalloc reports its version as <major>.<minor>.<bugfix>-<nrev>-g<gid>
# (the contents of the release VERSION file), while EXPECTED_VERSION is the
# <major>.<minor>.<bugfix> release number.  Compare the release component
# exactly, never as a substring, so 5.4.0 does not match 15.4.0.
EXPECTED_RELEASE="${EXPECTED_VERSION%%-*}"

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

fail() {
    printf 'FAIL: %s\n' "$*" >&2
}

assert_release_version() {
    local reported="$1"
    local context="$2"
    local release

    if [[ -z "${reported}" ]]; then
        fail "${context}: empty version string"
        return 1
    fi

    release="${reported%%-*}"
    if [[ "${release}" != "${EXPECTED_RELEASE}" ]]; then
        fail "${context}: version mismatch: expected=<${EXPECTED_RELEASE}> actual=<${reported}>"
        return 1
    fi

    printf 'PASS: %s reports version %s\n' "${context}" "${reported}"
}

test_config_version() {
    local output rc

    if [[ ! -x "${JEMALLOC_CONFIG}" ]]; then
        fail "jemalloc-config not executable at ${JEMALLOC_CONFIG}"
        return 1
    fi

    if output="$("${JEMALLOC_CONFIG}" --version 2>&1)"; then
        :
    else
        rc=$?
        fail "jemalloc-config --version exited ${rc}: ${output}"
        return 1
    fi

    assert_release_version "${output}" "jemalloc-config --version"
}

test_allocator_api() {
    local src="${WORKDIR}/je_probe.c"
    local bin="${WORKDIR}/je_probe"
    local output rc api_version allocated

    cat > "${src}" <<'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <jemalloc/jemalloc.h>

int main(void)
{
    const char *version = NULL;
    size_t vlen = sizeof(version);
    size_t alen = 0;
    size_t allocated = 0;
    unsigned char *buf;
    size_t i;

    if (mallctl("version", &version, &vlen, NULL, 0) != 0) {
        fprintf(stderr, "mallctl(\"version\") failed\n");
        return 1;
    }
    if (version == NULL || version[0] == '\0') {
        fprintf(stderr, "mallctl(\"version\") returned an empty string\n");
        return 1;
    }
    printf("JEMALLOC_API_VERSION=%s\n", version);

    buf = (unsigned char *)malloc(4096);
    if (buf == NULL) {
        fprintf(stderr, "jemalloc malloc failed\n");
        return 1;
    }
    memset(buf, 0x5a, 4096);
    for (i = 0; i < 4096; i++) {
        if (buf[i] != 0x5a) {
            fprintf(stderr, "allocator data mismatch at offset %zu\n", i);
            free(buf);
            return 1;
        }
    }

    alen = sizeof(allocated);
    if (mallctl("stats.allocated", &allocated, &alen, NULL, 0) != 0) {
        fprintf(stderr, "mallctl(\"stats.allocated\") failed\n");
        free(buf);
        return 1;
    }
    printf("JEMALLOC_ALLOCATED=%zu\n", allocated);

    free(buf);
    printf("ALLOC_ROUNDTRIP_OK\n");
    return 0;
}
EOF

    if output="$(gcc -I"${INCLUDE_DIR}" -o "${bin}" "${src}" \
            -L"${LIB_DIR}" -Wl,-rpath,"${LIB_DIR}" -ljemalloc 2>&1)"; then
        :
    else
        rc=$?
        fail "compile/link against libjemalloc failed (exit ${rc}): ${output}"
        return 1
    fi

    if output="$("${bin}" 2>&1)"; then
        :
    else
        rc=$?
        fail "jemalloc API probe exited ${rc}: ${output}"
        return 1
    fi

    api_version="$(printf '%s\n' "${output}" | sed -n 's/^JEMALLOC_API_VERSION=//p')"
    if ! assert_release_version "${api_version}" "mallctl(version)"; then
        return 1
    fi

    allocated="$(printf '%s\n' "${output}" | sed -n 's/^JEMALLOC_ALLOCATED=//p')"
    if [[ -z "${allocated}" ]]; then
        fail "mallctl(stats.allocated) did not report a value: ${output}"
        return 1
    fi
    if (( allocated < 1 )); then
        fail "jemalloc reported no allocated bytes for the live allocator: ${output}"
        return 1
    fi

    if ! printf '%s\n' "${output}" | grep -q '^ALLOC_ROUNDTRIP_OK$'; then
        fail "malloc/memset/verify/free round-trip did not complete: ${output}"
        return 1
    fi

    printf 'PASS: malloc/free round-trip through libjemalloc (%s bytes tracked)\n' "${allocated}"
}

main() {
    local failures=0

    WORKDIR="$(mktemp -d)"
    if [[ ! -d "${WORKDIR}" ]]; then
        printf 'FAIL: cannot create temporary working directory\n' >&2
        return 1
    fi

    if ! test_config_version; then
        failures=$((failures + 1))
    fi
    if ! test_allocator_api; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
