#!/bin/bash
set -euo pipefail

# The native harness injects EXPECTED_VERSION as the jvarkit release date tag
# that names the Dockerfile source archive
# (https://github.com/lindenb/jvarkit/archive/refs/tags/v${VERSION}.tar.gz).
# For this task the tag is v2026.04.30 (commit fc2356a347e1ec9b12d586c7a096c0d61bfbe8c1).
#
# The runtime artifact does not embed that date. At the pinned revision the
# manifest values are deterministic:
#   * build.gradle hardcodes the manifest "Release" attribute to "v2024.08.25".
#   * build.gradle derives "Git-Hash" from `git rev-parse --short HEAD` and the
#     catch branch returns the literal "undefined". The image is built from a
#     GitHub tag tarball (no .git tree) in a builder that installs no git, so
#     the Git-Hash is always "undefined".
#   * JvarkitCentral prints JVarkitVersion.getGitHash() for `--version`.
#   * Launcher prints JVarkitVersion.getVersion() for `vcfhead --version`, and
#     getVersion() is getRelease() + "-" + getGitHash() when the hash is
#     present, i.e. "v2024.08.25-undefined".
# The checks below therefore compare the reported values against those exact
# strings instead of a shape-only regex, so an artifact built from a different
# recipe/revision (different hardcoded Release or real git hash) is rejected.
: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

if [[ ! "${EXPECTED_VERSION}" =~ ^v?[0-9]{4}\.[0-9]{2}\.[0-9]{2}$ ]]; then
    printf 'FAIL: EXPECTED_VERSION is not a jvarkit date tag: <%s>\n' \
        "${EXPECTED_VERSION}" >&2
    exit 1
fi

EXPECTED_CENTRAL_VERSION="undefined"
EXPECTED_TOOL_VERSION="v2024.08.25-undefined"

JAVA_BIN="java"
JAR_PATH="/opt/jvarkit/dist/jvarkit.jar"
DIST_DIR="/opt/jvarkit/dist"

WORKDIR=""

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

test_java_runtime() {
    local output rc

    require_command "${JAVA_BIN}" || return 1

    if output="$("${JAVA_BIN}" -version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: "%s -version" exited %s: %s\n' \
            "${JAVA_BIN}" "${rc}" "${output}" >&2
        return 1
    fi

    printf 'PASS: java runtime available: %s\n' "${output%%$'\n'*}"
}

test_jar_layout() {
    if [[ ! -d "${DIST_DIR}" ]]; then
        printf 'FAIL: jvarkit distribution directory not found: %s\n' \
            "${DIST_DIR}" >&2
        return 1
    fi

    if [[ ! -f "${JAR_PATH}" || ! -s "${JAR_PATH}" ]]; then
        printf 'FAIL: jvarkit jar missing or empty: %s\n' "${JAR_PATH}" >&2
        return 1
    fi

    if [[ "${JVARKIT_JAR:-}" != "${JAR_PATH}" ]]; then
        printf 'FAIL: JVARKIT_JAR env mismatch: expected=<%s> actual=<%s>\n' \
            "${JAR_PATH}" "${JVARKIT_JAR:-}" >&2
        return 1
    fi

    if [[ "${JVARKIT_DIST:-}" != "${DIST_DIR}" ]]; then
        printf 'FAIL: JVARKIT_DIST env mismatch: expected=<%s> actual=<%s>\n' \
            "${DIST_DIR}" "${JVARKIT_DIST:-}" >&2
        return 1
    fi

    printf 'PASS: jar installed at %s and JVARKIT env matches the Dockerfile\n' \
        "${JAR_PATH}"
}

test_cli_dispatch() {
    local output rc

    if output="$("${JAVA_BIN}" -jar "${JAR_PATH}" --help 2>/dev/null)"; then
        :
    else
        rc=$?
        printf 'FAIL: "jvarkit --help" exited %s\n' "${rc}" >&2
        return 1
    fi

    if [[ "${output}" != *"JVARKIT"* ]]; then
        printf 'FAIL: jvarkit --help did not print the JVARKIT banner\n' >&2
        return 1
    fi

    if [[ "${output}" != *"vcfhead"* ]]; then
        printf 'FAIL: jvarkit --help did not list the vcfhead tool\n' >&2
        return 1
    fi

    printf 'PASS: central dispatcher lists the amalgamated tools\n'
}

test_pinned_build_metadata() {
    local central tool rc

    if central="$("${JAVA_BIN}" -jar "${JAR_PATH}" --version 2>/dev/null)"; then
        :
    else
        rc=$?
        printf 'FAIL: "jvarkit --version" exited %s\n' "${rc}" >&2
        return 1
    fi

    if [[ "${central}" != "${EXPECTED_CENTRAL_VERSION}" ]]; then
        printf 'FAIL: jvarkit --version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_CENTRAL_VERSION}" "${central}" >&2
        return 1
    fi

    if tool="$("${JAVA_BIN}" -jar "${JAR_PATH}" vcfhead --version 2>/dev/null)"; then
        :
    else
        rc=$?
        printf 'FAIL: "jvarkit vcfhead --version" exited %s\n' "${rc}" >&2
        return 1
    fi

    if [[ "${tool}" != "${EXPECTED_TOOL_VERSION}" ]]; then
        printf 'FAIL: vcfhead --version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_TOOL_VERSION}" "${tool}" >&2
        return 1
    fi

    printf 'PASS: pinned build metadata: central=%s vcfhead=%s (release tag %s)\n' \
        "${central}" "${tool}" "${EXPECTED_VERSION}"
}

write_input_vcf() {
    {
        printf '%s\n' '##fileformat=VCFv4.2'
        printf '%s\n' '##contig=<ID=chr1,length=1000>'
        printf '#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\n'
        printf 'chr1\t100\t.\tA\tG\t.\t.\t.\n'
        printf 'chr1\t200\t.\tC\tT\t.\t.\t.\n'
        printf 'chr1\t300\t.\tG\tA\t.\t.\t.\n'
    } > "${WORKDIR}/input.vcf"
}

count_variant_lines() {
    local text="$1" line variants=0

    while IFS= read -r line; do
        case "${line}" in
            \#*) ;;
            chr1*) variants=$((variants + 1)) ;;
        esac
    done <<< "${text}"

    printf '%s' "${variants}"
}

test_vcfhead_stdout() {
    local output rc variants

    if output="$("${JAVA_BIN}" -jar "${JAR_PATH}" vcfhead -n 2 \
        "${WORKDIR}/input.vcf" 2>"${WORKDIR}/vcfhead-stdout.err")"; then
        :
    else
        rc=$?
        printf 'FAIL: "vcfhead -n 2" exited %s:\n' "${rc}" >&2
        printf '%s\n' "$(<"${WORKDIR}/vcfhead-stdout.err")" >&2
        return 1
    fi

    if [[ "${output}" != *"#CHROM"* ]]; then
        printf 'FAIL: vcfhead output lost the VCF column header\n' >&2
        return 1
    fi

    if [[ "${output}" != *$'\nchr1\t100\t'* && "${output}" != chr1$'\t100\t'* ]]; then
        printf 'FAIL: vcfhead did not emit the first variant record\n' >&2
        return 1
    fi

    if [[ "${output}" != *$'\nchr1\t200\t'* && "${output}" != chr1$'\t200\t'* ]]; then
        printf 'FAIL: vcfhead did not emit the second variant record\n' >&2
        return 1
    fi

    if [[ "${output}" == *$'\nchr1\t300\t'* || "${output}" == chr1$'\t300\t'* ]]; then
        printf 'FAIL: vcfhead emitted the third variant although -n 2 was given\n' >&2
        return 1
    fi

    variants="$(count_variant_lines "${output}")"
    if [[ "${variants}" != "2" ]]; then
        printf 'FAIL: expected exactly 2 variant lines from "-n 2", got %s\n' \
            "${variants}" >&2
        printf 'actual output:\n%s\n' "${output}" >&2
        return 1
    fi

    printf 'PASS: vcfhead -n 2 streamed the header and the first two records\n'
}

test_vcfhead_output_file() {
    local rc content

    if "${JAVA_BIN}" -jar "${JAR_PATH}" vcfhead -n 1 \
        -o "${WORKDIR}/out.vcf" "${WORKDIR}/input.vcf" \
        >"${WORKDIR}/vcfhead-file.out" 2>"${WORKDIR}/vcfhead-file.err"; then
        :
    else
        rc=$?
        printf 'FAIL: "vcfhead -n 1 -o out.vcf" exited %s:\n' "${rc}" >&2
        printf '%s\n' "$(<"${WORKDIR}/vcfhead-file.err")" >&2
        return 1
    fi

    if [[ ! -s "${WORKDIR}/out.vcf" ]]; then
        printf 'FAIL: vcfhead -o did not create a non-empty output file\n' >&2
        return 1
    fi

    content="$(<"${WORKDIR}/out.vcf")"

    if [[ "${content}" != *"chr1"$'\t'"100"* ]]; then
        printf 'FAIL: written VCF is missing the first variant\n' >&2
        return 1
    fi

    if [[ "${content}" == *"chr1"$'\t'"200"* ]]; then
        printf 'FAIL: written VCF contains a variant beyond -n 1\n' >&2
        return 1
    fi

    printf 'PASS: vcfhead wrote the first record to a file and it reads back\n'
}

test_core_function() {
    write_input_vcf

    if ! test_vcfhead_stdout; then
        return 1
    fi

    if ! test_vcfhead_output_file; then
        return 1
    fi
}

main() {
    local failures=0

    require_command mktemp || {
        printf 'TESTS_FAILED: mktemp is required\n' >&2
        return 1
    }

    WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/jvarkit-test.XXXXXX")" || {
        printf 'TESTS_FAILED: could not create a temporary workspace\n' >&2
        return 1
    }

    if ! test_java_runtime; then
        failures=$((failures + 1))
    fi
    if ! test_jar_layout; then
        failures=$((failures + 1))
    fi
    if ! test_cli_dispatch; then
        failures=$((failures + 1))
    fi
    if ! test_pinned_build_metadata; then
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
