#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

SCALA_BIN="scala"
SCALAC_BIN="scalac"
WORKDIR=""

cleanup() {
    if [[ -n "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}

fail() {
    printf 'FAIL: %s\n' "$*" >&2
    return 1
}

test_binaries_present() {
    local bin
    for bin in "${SCALA_BIN}" "${SCALAC_BIN}"; do
        if ! command -v "${bin}" >/dev/null 2>&1; then
            fail "binary not found on PATH: ${bin}"
            return 1
        fi
    done
    printf 'PASS: binaries present: %s, %s\n' "${SCALA_BIN}" "${SCALAC_BIN}"
}

# `scala` reports its version in the fixed form
#   "Scala code runner version <ver> -- Copyright ..."
# (GenericRunnerCommand.cmdDesc == "code runner" fed to
# scala.util.Properties.versionFor). Parse the version token out and require
# exact equality with EXPECTED_VERSION, rejecting any other release.
test_scala_version() {
    local output prefix rest reported

    if ! output="$("${SCALA_BIN}" -version 2>&1)"; then
        fail "${SCALA_BIN} -version exited non-zero: ${output}"
        return 1
    fi

    prefix="Scala code runner version "
    if [[ "${output}" != "${prefix}"* ]]; then
        fail "unexpected ${SCALA_BIN} -version format: ${output}"
        return 1
    fi

    rest="${output#"${prefix}"}"
    reported="${rest%% *}"

    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        fail "version mismatch: expected=<${EXPECTED_VERSION}> actual=<${reported}>"
        return 1
    fi

    printf 'PASS: exact scala version: %s\n' "${reported}"
}

# `scalac` reports "Scala compiler version <ver> -- ..." (nsc Properties
# propCategory == "compiler" via scala.util.Properties.versionFor).
test_scalac_version() {
    local output prefix rest reported

    if ! output="$("${SCALAC_BIN}" -version 2>&1)"; then
        fail "${SCALAC_BIN} -version exited non-zero: ${output}"
        return 1
    fi

    prefix="Scala compiler version "
    if [[ "${output}" != "${prefix}"* ]]; then
        fail "unexpected ${SCALAC_BIN} -version format: ${output}"
        return 1
    fi

    rest="${output#"${prefix}"}"
    reported="${rest%% *}"

    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        fail "compiler version mismatch: expected=<${EXPECTED_VERSION}> actual=<${reported}>"
        return 1
    fi

    printf 'PASS: exact scalac version: %s\n' "${reported}"
}

# Real core data path: compile a source file to bytecode with scalac, then run
# the resulting object with the scala runner and check its output.
test_compile_and_run() {
    local workdir output

    workdir="$(mktemp -d)"
    WORKDIR="${workdir}"

    cat > "${workdir}/Hello.scala" <<'SCALA'
object Hello {
  def main(args: Array[String]): Unit = println("Hello, Scala!")
}
SCALA

    if ! output="$(cd "${workdir}" && "${SCALAC_BIN}" Hello.scala 2>&1)"; then
        fail "scalac failed to compile Hello.scala: ${output}"
        return 1
    fi
    if [[ ! -f "${workdir}/Hello.class" ]]; then
        fail "scalac produced no Hello.class in ${workdir}"
        return 1
    fi

    if ! output="$(cd "${workdir}" && "${SCALA_BIN}" Hello 2>&1)"; then
        fail "scala Hello exited non-zero: ${output}"
        return 1
    fi

    if [[ "${output}" != "Hello, Scala!" ]]; then
        fail "unexpected run output: expected=<Hello, Scala!> actual=<${output}>"
        return 1
    fi

    printf 'PASS: compile and run produced: %s\n' "${output}"
}

# Real evaluation path: `scala -e <expr>` runs the expression through the
# script runner and exits with the computed result.
test_eval_expression() {
    local output expected="eval-ok: 42"

    if ! output="$("${SCALA_BIN}" -e 'println("eval-ok: " + (21 * 2))' 2>&1)"; then
        fail "scala -e exited non-zero: ${output}"
        return 1
    fi

    if [[ "${output}" != "${expected}" ]]; then
        fail "unexpected eval output: expected=<${expected}> actual=<${output}>"
        return 1
    fi

    printf 'PASS: scala -e produced: %s\n' "${output}"
}

main() {
    local failures=0

    trap cleanup EXIT

    if ! test_binaries_present; then failures=$((failures + 1)); fi
    if ! test_scala_version; then failures=$((failures + 1)); fi
    if ! test_scalac_version; then failures=$((failures + 1)); fi
    if ! test_compile_and_run; then failures=$((failures + 1)); fi
    if ! test_eval_expression; then failures=$((failures + 1)); fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
