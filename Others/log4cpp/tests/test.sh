#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

INCLUDE_DIR="/usr/include/orocos"
LIB_DIR="/usr/lib"
LIBRARY_NAME="orocos-log4cpp"
PC_FILE="/usr/lib/pkgconfig/orocos-log4cpp.pc"
SO_FILE="/usr/lib/liborocos-log4cpp.so.${EXPECTED_VERSION}"

WORKDIR=""

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

fail() {
    printf 'FAIL: %s\n' "$*" >&2
}

test_version() {
    local actual

    if [[ ! -f "${PC_FILE}" ]]; then
        fail "version metadata not found: ${PC_FILE}"
        return 1
    fi

    actual="$(sed -n 's/^Version:[[:space:]]*//p' "${PC_FILE}")"
    actual="${actual//[[:space:]]/}"

    if [[ -z "${actual}" ]]; then
        fail "could not parse Version from ${PC_FILE}"
        return 1
    fi

    if [[ "${actual}" != "${EXPECTED_VERSION}" ]]; then
        fail "version mismatch: expected=<${EXPECTED_VERSION}> actual=<${actual}>"
        return 1
    fi

    if [[ ! -e "${SO_FILE}" ]]; then
        fail "shared library for exact version missing: ${SO_FILE}"
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${actual}"
}

test_core_function() {
    local src="${WORKDIR}/log4cpp_probe.cpp"
    local bin="${WORKDIR}/log4cpp_probe"
    local logfile="${WORKDIR}/program.log"
    local consolefile="${WORKDIR}/console.out"
    local content console output

    cat > "${src}" <<'EOF'
#include <log4cpp/Category.hh>
#include <log4cpp/FileAppender.hh>
#include <log4cpp/OstreamAppender.hh>
#include <log4cpp/BasicLayout.hh>
#include <log4cpp/Priority.hh>
#include <iostream>

int main(int argc, char** argv) {
    if (argc < 2) {
        std::cerr << "usage: log4cpp_probe <logfile>" << std::endl;
        return 2;
    }

    log4cpp::Category& root = log4cpp::Category::getRoot();
    root.setPriority(log4cpp::Priority::INFO);

    log4cpp::FileAppender* fileAppender =
        new log4cpp::FileAppender("file", argv[1], false);
    fileAppender->setLayout(new log4cpp::BasicLayout());
    root.addAppender(fileAppender);

    log4cpp::OstreamAppender* consoleAppender =
        new log4cpp::OstreamAppender("console", &std::cout);
    consoleAppender->setLayout(new log4cpp::BasicLayout());
    root.addAppender(consoleAppender);

    root.debug("debug-must-be-filtered");
    root.info("info-message-42");
    root.error("error-message-99");

    log4cpp::Category::shutdown();
    return 0;
}
EOF

    if ! output="$(g++ -std=c++14 -I"${INCLUDE_DIR}" -L"${LIB_DIR}" "${src}" \
            -l"${LIBRARY_NAME}" -pthread -o "${bin}" 2>&1)"; then
        fail "g++ compile/link of log4cpp probe failed: ${output}"
        return 1
    fi

    if ! output="$("${bin}" "${logfile}" >"${consolefile}" 2>&1)"; then
        fail "log4cpp probe exited non-zero: ${output}"
        return 1
    fi

    if [[ ! -f "${logfile}" ]]; then
        fail "log file was not created: ${logfile}"
        return 1
    fi

    content="$(cat "${logfile}")"

    if [[ "${content}" != *"info-message-42"* ]]; then
        fail "INFO message missing from log file: <${content}>"
        return 1
    fi
    if [[ "${content}" != *"error-message-99"* ]]; then
        fail "ERROR message missing from log file: <${content}>"
        return 1
    fi
    if [[ "${content}" != *"ERROR"* ]]; then
        fail "ERROR priority name missing from BasicLayout output: <${content}>"
        return 1
    fi
    if [[ "${content}" == *"debug-must-be-filtered"* ]]; then
        fail "DEBUG message below category priority was not filtered: <${content}>"
        return 1
    fi

    console="$(cat "${consolefile}")"
    if [[ "${console}" != *"error-message-99"* ]]; then
        fail "ERROR message missing from OstreamAppender output: <${console}>"
        return 1
    fi

    printf 'PASS: core function (file + console logging, priority filtering)\n'
}

main() {
    local failures=0

    WORKDIR="$(mktemp -d)"
    if [[ ! -d "${WORKDIR}" ]]; then
        fail "cannot create temporary working directory"
        return 1
    fi

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
