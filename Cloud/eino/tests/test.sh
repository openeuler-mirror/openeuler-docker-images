#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

EINO_MODULE="github.com/cloudwego/eino"
EINO_DIR="/eino"
# Eino core (github.com/cloudwego/eino) has no version command and ships no
# release marker inside the tree at this revision. The exact release is pinned
# by the Dockerfile tarball URL (v${VERSION}); it cannot be re-derived from the
# shipped source without echoing a value the test itself supplied. The tests
# below therefore prove the shipped source is present and functionally usable,
# and deliberately do not make a circular release-equality claim.
PINNED_VERSION="${EXPECTED_VERSION#v}"
PINNED_MODULE_VERSION="v${PINNED_VERSION}"

WORKDIR=""
ACCEPTANCE_OUTPUT=""

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

require_command() {
    local tool="$1"
    if ! command -v "${tool}" >/dev/null 2>&1; then
        printf 'FAIL: required runtime command not found: %s\n' "${tool}" >&2
        return 1
    fi
}

# Verifies that the bundled toolchain is usable and that the image's Go
# environment is self-consistent (GOTOOLCHAIN=local, reported platform matches
# GOOS/GOARCH). The concrete Go release is set by the Dockerfile ARG GO_VERSION
# and is intentionally not asserted here: only the eino EXPECTED_VERSION is
# injected, so this check is incidental and must not be read as validating the
# pinned Go release.
test_toolchain_environment() {
    local output reported goversion platform goos goarch gotoolchain

    if output="$(go version 2>&1)"; then
        :
    else
        printf 'FAIL: "go version" failed: %s\n' "${output}" >&2
        return 1
    fi

    if [[ ! "${output}" =~ ^go\ version\ (go[0-9][A-Za-z0-9._+-]*)\ ([A-Za-z0-9._/-]+)$ ]]; then
        printf 'FAIL: unexpected "go version" output: <%s>\n' "${output}" >&2
        return 1
    fi
    goversion="${BASH_REMATCH[1]}"
    platform="${BASH_REMATCH[2]}"

    if reported="$(go env GOVERSION 2>&1)"; then
        :
    else
        printf 'FAIL: "go env GOVERSION" failed: %s\n' "${reported}" >&2
        return 1
    fi
    if [[ "${reported}" != "${goversion}" ]]; then
        printf 'FAIL: toolchain version mismatch: go version=<%s> go env=<%s>\n' \
            "${goversion}" "${reported}" >&2
        return 1
    fi

    goos="$(go env GOOS)"
    goarch="$(go env GOARCH)"
    if [[ "${platform}" != "${goos}/${goarch}" ]]; then
        printf 'FAIL: toolchain platform mismatch: reported=<%s> env=<%s/%s>\n' \
            "${platform}" "${goos}" "${goarch}" >&2
        return 1
    fi

    gotoolchain="$(go env GOTOOLCHAIN)"
    if [[ "${gotoolchain}" != "local" ]]; then
        printf 'FAIL: GOTOOLCHAIN expected <local>, actual <%s>\n' \
            "${gotoolchain}" >&2
        return 1
    fi

    printf 'PASS: go toolchain usable and environment consistent: %s (%s)\n' \
        "${goversion}" "${platform}"
}

test_eino_module() {
    local module_line=""
    local first_line=""

    if [[ ! -f "${EINO_DIR}/go.mod" ]]; then
        printf 'FAIL: eino module file not found: %s/go.mod\n' "${EINO_DIR}" >&2
        return 1
    fi

    if IFS= read -r first_line < "${EINO_DIR}/go.mod"; then
        module_line="${first_line}"
    fi
    if [[ "${module_line}" != "module ${EINO_MODULE}" ]]; then
        printf 'FAIL: unexpected module declaration in %s/go.mod: <%s>\n' \
            "${EINO_DIR}" "${module_line}" >&2
        return 1
    fi

    printf 'PASS: eino framework source present at %s (module %s)\n' \
        "${EINO_DIR}" "${EINO_MODULE}"
}

build_acceptance_module() {
    local output rc

    WORKDIR="$(mktemp -d)" || {
        printf 'FAIL: could not create a temporary workspace\n' >&2
        return 1
    }

    cat > "${WORKDIR}/go.mod" <<EOF
module oe-eino-acceptance

go 1.18

require ${EINO_MODULE} ${PINNED_MODULE_VERSION}

replace ${EINO_MODULE} => ${EINO_DIR}
EOF

    if [[ -f "${EINO_DIR}/go.sum" ]]; then
        cp "${EINO_DIR}/go.sum" "${WORKDIR}/go.sum"
    fi

    cat > "${WORKDIR}/main.go" <<'EOF'
package main

import (
	"context"
	"fmt"
	"os"
	"strings"

	"github.com/cloudwego/eino/compose"
)

func must(err error) {
	if err != nil {
		fmt.Fprintln(os.Stderr, "ERROR:", err)
		os.Exit(1)
	}
}

func main() {
	ctx := context.Background()

	graph := compose.NewGraph[string, string]()

	must(graph.AddLambdaNode("normalize", compose.InvokableLambda(
		func(_ context.Context, in string) (string, error) {
			return strings.ToUpper(strings.TrimSpace(in)), nil
		})))

	must(graph.AddLambdaNode("decorate", compose.InvokableLambda(
		func(_ context.Context, in string) (string, error) {
			return in + "-eino", nil
		})))

	must(graph.AddEdge(compose.START, "normalize"))
	must(graph.AddEdge("normalize", "decorate"))
	must(graph.AddEdge("decorate", compose.END))

	runnable, err := graph.Compile(ctx)
	must(err)

	out, err := runnable.Invoke(ctx, "  hello  ")
	must(err)

	fmt.Printf("GRAPH_RESULT=%s\n", out)
}
EOF

    if output="$(cd "${WORKDIR}" && GOFLAGS=-mod=mod GOPROXY=off GOSUMDB=off GOTOOLCHAIN=local go build -o "${WORKDIR}/oe-eino-acceptance" . 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: building the eino acceptance program exited %s:\n%s\n' \
            "${rc}" "${output}" >&2
        return 1
    fi

    if ACCEPTANCE_OUTPUT="$("${WORKDIR}/oe-eino-acceptance" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: eino acceptance program exited %s:\n%s\n' \
            "${rc}" "${ACCEPTANCE_OUTPUT}" >&2
        return 1
    fi

    printf 'PASS: built the acceptance module offline against %s and ran it\n' \
        "${EINO_DIR}"
}

field_from_output() {
    local key="$1" line
    while IFS= read -r line; do
        if [[ "${line}" == "${key}="* ]]; then
            printf '%s' "${line#"${key}="}"
            return 0
        fi
    done <<< "${ACCEPTANCE_OUTPUT}"
    return 1
}

test_core_function() {
    local actual expected="HELLO-eino"

    if ! actual="$(field_from_output GRAPH_RESULT)"; then
        printf 'FAIL: acceptance program did not report a graph result\n' >&2
        return 1
    fi
    if [[ "${actual}" != "${expected}" ]]; then
        printf 'FAIL: compose graph result mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${actual}" >&2
        return 1
    fi

    printf 'PASS: compose graph executed START->normalize->decorate->END: %s\n' \
        "${actual}"
}

main() {
    local failures=0

    if ! require_command go; then
        printf 'TESTS_FAILED: the go toolchain is required\n' >&2
        return 1
    fi
    if ! require_command mktemp; then
        printf 'TESTS_FAILED: mktemp is required\n' >&2
        return 1
    fi

    if ! test_toolchain_environment; then
        failures=$((failures + 1))
    fi
    if ! test_eino_module; then
        failures=$((failures + 1))
    fi
    if ! build_acceptance_module; then
        failures=$((failures + 1))
    else
        if ! test_core_function; then
            failures=$((failures + 1))
        fi
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
