#!/bin/bash
# KunpengTest functional test for apache parquet-format (source distribution).
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version dir name), DOCKER_NAMESPACE, DOCKER_PACKAGE,
# DOCKER_TAG, DOCKER_IMAGE.
#
# The Dockerfile extracts apache-parquet-format-<VERSION> into /usr/local/parquet.
# This is the Apache Parquet format specification: Thrift IDL + documentation,
# with no runtime binary. We therefore assert (1) the release version recorded in
# the Maven project descriptor pom.xml and (2) the canonical Thrift definition
# that describes the Parquet file format.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

APP_HOME="/usr/local/parquet"
POM="${APP_HOME}/pom.xml"
THRIFT="${APP_HOME}/src/main/thrift/parquet.thrift"

pom_version() {
    grep -A1 '<artifactId>parquet-format</artifactId>' "${POM}" 2>/dev/null \
        | grep '<version>' \
        | head -1 \
        | sed -n 's/[[:space:]]*<version>\([^<]*\)<\/version>[[:space:]]*/\1/p'
}

test_version() {
    local out
    if [ ! -f "${POM}" ]; then
        printf 'FAIL: %s not found\n' "${POM}"
        return 1
    fi
    out="$(pom_version)"
    if [ -z "${out}" ]; then
        printf 'FAIL: could not extract version from %s\n' "${POM}"
        return 1
    fi
    if [ "${out}" = "${EXPECTED_VERSION}" ]; then
        printf 'PASS: parquet-format version %s\n' "${out}"
        return 0
    fi
    printf 'FAIL: expected parquet-format version %s, got %s\n' "${EXPECTED_VERSION}" "${out}"
    return 1
}

test_thrift_spec() {
    if [ ! -f "${THRIFT}" ]; then
        printf 'FAIL: %s not found\n' "${THRIFT}"
        return 1
    fi
    if grep -q 'namespace java org.apache.parquet.format' "${THRIFT}" \
        && grep -q 'struct FileMetaData' "${THRIFT}"; then
        printf 'PASS: parquet.thrift defines the Parquet format (java namespace + FileMetaData)\n'
        return 0
    fi
    printf 'FAIL: %s missing expected Parquet format definitions\n' "${THRIFT}"
    return 1
}

main() {
    local failures=0
    test_version     || failures=$((failures + 1))
    test_thrift_spec || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"
