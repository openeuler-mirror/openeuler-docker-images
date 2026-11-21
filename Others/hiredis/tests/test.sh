#!/bin/bash
# KunpengTest functional test for hiredis (C client library for Redis).
#
# The image installs the hiredis headers and shared library under
# /usr/local/{include,lib} (default `make install` PREFIX) plus a gcc/make
# toolchain. hiredis ships no CLI that reports a version, so the version is
# read from the installed header macros HIREDIS_MAJOR/HIREDIS_MINOR/
# HIREDIS_PATCH by compiling and running a tiny probe program. The functional
# case exercises the hiredis client library directly (RESP command formatting
# and reply parsing), which needs no redis-server.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/hiredis-test.XXXXXX")"
HIREDIS_INCLUDE="${HIREDIS_INCLUDE:-/usr/local/include}"
HIREDIS_LIB="${HIREDIS_LIB:-/usr/local/lib}"
CC="${CC:-gcc}"

cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

compile_probe() {
    local src="$1" bin="$2"
    "${CC}" -I"${HIREDIS_INCLUDE}" -L"${HIREDIS_LIB}" -o "${bin}" "${src}" -lhiredis 2>&1
}

run_probe() {
    local bin="$1"
    LD_LIBRARY_PATH="${HIREDIS_LIB}${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" "${bin}" 2>&1
}

test_version() {
    local src="${WORKDIR}/version.c"
    local bin="${WORKDIR}/hiredis-version"
    local compile_out run_out rc

    if ! command -v "${CC}" >/dev/null 2>&1; then
        echo "FAIL: compiler '${CC}' not found in PATH"
        return 1
    fi

    cat > "${src}" <<'EOF'
#include <stdio.h>
#include <hiredis/hiredis.h>

int main(void) {
    printf("%d.%d.%d\n", HIREDIS_MAJOR, HIREDIS_MINOR, HIREDIS_PATCH);
    return 0;
}
EOF

    if ! compile_out="$(compile_probe "${src}" "${bin}")"; then
        echo "FAIL: failed to compile version probe: $(printf '%s' "${compile_out}" | tr '\n' ' ' | cut -c1-300)"
        return 1
    fi

    run_out="$(run_probe "${bin}")"
    rc=$?
    if [ "${rc}" -ne 0 ]; then
        echo "FAIL: version probe exited ${rc}: $(printf '%s' "${run_out}" | tr '\n' ' ' | cut -c1-300)"
        return 1
    fi

    if [ "${run_out}" = "${EXPECTED_VERSION}" ]; then
        echo "PASS: exact hiredis version ${run_out}"
        return 0
    fi
    echo "FAIL: expected hiredis version '${EXPECTED_VERSION}', got '${run_out}'"
    return 1
}

test_core_function() {
    local src="${WORKDIR}/probe.c"
    local bin="${WORKDIR}/hiredis-probe"
    local compile_out run_out rc

    if ! command -v "${CC}" >/dev/null 2>&1; then
        echo "FAIL: compiler '${CC}' not found in PATH"
        return 1
    fi

    cat > "${src}" <<'EOF'
#include <stdio.h>
#include <string.h>
#include <hiredis/hiredis.h>
#include <hiredis/read.h>

int main(void) {
    char *cmd = NULL;
    int len = redisFormatCommand(&cmd, "SET %s %s", "foo", "bar");
    if (len < 0 || cmd == NULL) {
        fprintf(stderr, "redisFormatCommand failed\n");
        return 1;
    }

    const char *expected = "*3\r\n$3\r\nSET\r\n$3\r\nfoo\r\n$3\r\nbar\r\n";
    size_t elen = strlen(expected);
    if ((size_t)len != elen || memcmp(cmd, expected, elen) != 0) {
        fprintf(stderr, "command format mismatch\n");
        redisFreeCommand(cmd);
        return 1;
    }
    redisFreeCommand(cmd);

    redisReader *reader = redisReaderCreate();
    if (reader == NULL) {
        fprintf(stderr, "redisReaderCreate failed\n");
        return 1;
    }

    const char *wire = "+PONG\r\n";
    if (redisReaderFeed(reader, wire, strlen(wire)) != REDIS_OK) {
        fprintf(stderr, "redisReaderFeed failed: %s\n", reader->errstr);
        redisReaderFree(reader);
        return 1;
    }

    redisReply *reply = NULL;
    if (redisReaderGetReply(reader, (void **)&reply) != REDIS_OK || reply == NULL) {
        fprintf(stderr, "redisReaderGetReply failed: %s\n", reader->errstr);
        redisReaderFree(reader);
        return 1;
    }

    if (reply->type != REDIS_REPLY_STATUS || strcmp(reply->str, "PONG") != 0) {
        fprintf(stderr, "unexpected reply\n");
        freeReplyObject(reply);
        redisReaderFree(reader);
        return 1;
    }

    freeReplyObject(reply);
    redisReaderFree(reader);

    printf("HIREDIS_PROBE_OK\n");
    return 0;
}
EOF

    if ! compile_out="$(compile_probe "${src}" "${bin}")"; then
        echo "FAIL: failed to compile core probe: $(printf '%s' "${compile_out}" | tr '\n' ' ' | cut -c1-300)"
        return 1
    fi

    run_out="$(run_probe "${bin}")"
    rc=$?
    if [ "${rc}" -ne 0 ]; then
        echo "FAIL: core probe exited ${rc}: $(printf '%s' "${run_out}" | tr '\n' ' ' | cut -c1-300)"
        return 1
    fi

    if [ "${run_out}" = "HIREDIS_PROBE_OK" ]; then
        echo "PASS: hiredis command format and reply parse data path"
        return 0
    fi
    echo "FAIL: unexpected core probe output: $(printf '%s' "${run_out}" | tr '\n' ' ' | cut -c1-300)"
    return 1
}

main() {
    local failures=0
    test_version || failures=$((failures + 1))
    test_core_function || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        return 0
    fi
    echo "TESTS_FAILED: ${failures} failure(s)"
    return 1
}

main "$@"