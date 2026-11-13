#!/bin/bash

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

SRUN_BIN="srun"
SCONTROL_BIN="scontrol"

test_version() {
    local out reported

    if ! command -v "${SRUN_BIN}" >/dev/null 2>&1; then
        echo "FAIL: ${SRUN_BIN} not found in PATH"
        return 1
    fi

    out="$("${SRUN_BIN}" --version 2>&1 || true)"
    if [[ "${out}" =~ ^slurm[[:space:]]+([0-9]+(\.[0-9]+)+)$ ]]; then
        reported="${BASH_REMATCH[1]}"
    else
        echo "FAIL: unexpected ${SRUN_BIN} --version output: <${out}>"
        return 1
    fi

    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        echo "FAIL: version mismatch: expected=<${EXPECTED_VERSION}> actual=<${reported}>"
        return 1
    fi

    echo "PASS: exact slurm version: ${reported}"
    return 0
}

test_hostlist_expand() {
    local out expected

    if ! command -v "${SCONTROL_BIN}" >/dev/null 2>&1; then
        echo "FAIL: ${SCONTROL_BIN} not found in PATH"
        return 1
    fi

    out="$("${SCONTROL_BIN}" show hostnames 'node[1-4]' 2>&1 || true)"
    expected=$'node1\nnode2\nnode3\nnode4'
    if [[ "${out}" != "${expected}" ]]; then
        echo "FAIL: hostnames expansion mismatch: expected=<${expected}> actual=<${out}>"
        return 1
    fi

    echo "PASS: scontrol show hostnames expands node[1-4]"
    return 0
}

test_hostlist_encode() {
    local out expected

    if ! command -v "${SCONTROL_BIN}" >/dev/null 2>&1; then
        echo "FAIL: ${SCONTROL_BIN} not found in PATH"
        return 1
    fi

    out="$("${SCONTROL_BIN}" show hostlist 'node1,node2,node3,node4' 2>&1 || true)"
    expected="node[1-4]"
    if [[ "${out}" != "${expected}" ]]; then
        echo "FAIL: hostlist encode mismatch: expected=<${expected}> actual=<${out}>"
        return 1
    fi

    echo "PASS: scontrol show hostlist encodes node1..node4"
    return 0
}

main() {
    local failures=0

    test_version || failures=$((failures + 1))
    test_hostlist_expand || failures=$((failures + 1))
    test_hostlist_encode || failures=$((failures + 1))

    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        return 0
    fi

    echo "TESTS_FAILED: ${failures} failure(s)"
    return 1
}

main "$@"
