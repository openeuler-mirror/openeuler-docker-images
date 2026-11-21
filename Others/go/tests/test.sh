#!/bin/bash

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

WORKDIR=""

cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_version() {
    local out reported

    if ! command -v go >/dev/null 2>&1; then
        echo "FAIL: go binary not found in PATH"
        return 1
    fi

    out="$(go version 2>&1)"
    reported="${out#go version go}"
    reported="${reported%% *}"

    if [ -z "${reported}" ]; then
        echo "FAIL: could not parse go version from output: ${out}"
        return 1
    fi

    if [ "${reported}" = "${EXPECTED_VERSION}" ]; then
        echo "PASS: exact go version: ${reported}"
        return 0
    fi

    echo "FAIL: expected go version ${EXPECTED_VERSION}, got ${reported} from '${out}'"
    return 1
}

test_core_function() {
    local dir out build_out

    dir="$(mktemp -d "${TMPDIR:-/tmp}/go-test.XXXXXX")"
    WORKDIR="${dir}"

    cat > "${dir}/main.go" <<'EOF'
package main

import "fmt"

func main() {
    fmt.Println("Hello from Go")
}
EOF

    if ! build_out="$(cd "${dir}" && GOCACHE="${dir}/gocache" go mod init example.com/hello 2>&1)"; then
        echo "FAIL: go mod init failed: ${build_out}"
        return 1
    fi

    if ! build_out="$(cd "${dir}" && GOCACHE="${dir}/gocache" go build -o hello . 2>&1)"; then
        echo "FAIL: go build failed: ${build_out}"
        return 1
    fi

    out="$("${dir}/hello" 2>&1)"
    if [ "${out}" = "Hello from Go" ]; then
        echo "PASS: compile and run Go program: ${out}"
        return 0
    fi

    echo "FAIL: unexpected program output: ${out}"
    return 1
}

main() {
    local failures=0

    test_version       || failures=$((failures + 1))
    test_core_function || failures=$((failures + 1))

    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        return 0
    fi

    echo "TESTS_FAILED: ${failures} failure(s)"
    return 1
}

main "$@"
