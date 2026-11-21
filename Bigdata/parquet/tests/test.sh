#!/bin/bash
# KunpengTest functional test for parquet (Apache Parquet Java source distribution).
#
# The image ships the parquet-java source tree under /usr/local/parquet (there is
# no compiled binary). The version is declared by the root Maven build descriptor
# pom.xml (groupId org.apache.parquet, artifactId parquet). Injected env vars:
# EXPECTED_VERSION, DOCKER_NAMESPACE, DOCKER_PACKAGE, DOCKER_TAG, DOCKER_IMAGE.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

PARQUET_HOME="/usr/local/parquet"

project_version() {
    awk '
        /<artifactId>parquet<\/artifactId>/ { found=1; next }
        found && /<version>/ {
            line = $0
            sub(/^[[:space:]]*<version>/, "", line)
            sub(/<\/version>.*$/, "", line)
            print line
            exit
        }
    ' "${PARQUET_HOME}/pom.xml" 2>/dev/null
}

test_version() {
    local got
    got="$(project_version)"
    if [ -z "${got}" ]; then
        printf 'FAIL: could not read project version from %s/pom.xml\n' "${PARQUET_HOME}"
        return 1
    fi
    if [ "${got}" = "${EXPECTED_VERSION}" ]; then
        printf 'PASS: pom.xml reports exact version %s\n' "${got}"
        return 0
    fi
    printf 'FAIL: expected version %s, got %s\n' "${EXPECTED_VERSION}" "${got}"
    return 1
}

test_source_tree() {
    local java_file
    java_file="${PARQUET_HOME}/parquet-hadoop/src/main/java/org/apache/parquet/hadoop/ParquetFileReader.java"
    if [ ! -f "${PARQUET_HOME}/pom.xml" ]; then
        printf 'FAIL: missing build descriptor %s/pom.xml\n' "${PARQUET_HOME}"
        return 1
    fi
    if [ ! -f "${java_file}" ]; then
        printf 'FAIL: missing core source file %s\n' "${java_file}"
        return 1
    fi
    if ! grep -q 'package org.apache.parquet.hadoop;' "${java_file}"; then
        printf 'FAIL: unexpected package declaration in %s\n' "${java_file}"
        return 1
    fi
    printf 'PASS: parquet-java source tree intact (pom.xml and ParquetFileReader.java)\n'
    return 0
}

main() {
    local failures=0
    test_version    || failures=$((failures + 1))
    test_source_tree || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"