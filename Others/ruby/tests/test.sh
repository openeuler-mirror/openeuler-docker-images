#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"
BINARY="ruby"

WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/ruby-test.XXXXXX")"
trap 'rm -rf "${WORKDIR}"' EXIT

test_version() {
    local output first_line reported="" rc

    if ! command -v "${BINARY}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found in PATH: %s\n' "${BINARY}" >&2
        return 1
    fi

    if output="$("${BINARY}" --version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: "%s --version" exited %s: %s\n' \
            "${BINARY}" "${rc}" "${output}" >&2
        return 1
    fi

    first_line="${output%%$'\n'*}"
    if [[ "${first_line}" =~ ^ruby[[:space:]]+([0-9]+\.[0-9]+\.[0-9]+) ]]; then
        reported="${BASH_REMATCH[1]}"
    fi

    if [[ -z "${reported}" ]]; then
        printf 'FAIL: no MAJOR.MINOR.TEENY version in first line: <%s>\n' \
            "${first_line}" >&2
        return 1
    fi

    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${reported}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${reported}"
}

run_ruby_script() {
    local script="$1" expected="$2" label="$3" output rc

    if output="$(cd "${WORKDIR}" && "${BINARY}" "${script}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: %s ("%s %s") exited %s: %s\n' \
            "${label}" "${BINARY}" "${script}" "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: %s result mismatch: expected=<%s> actual=<%s>\n' \
            "${label}" "${expected}" "${output}" >&2
        return 1
    fi

    return 0
}

test_core_function() {
    local expected="CORE_OK total=385"

    cat > "${WORKDIR}/probe.rb" <<'RUBY'
class Squares
  def initialize(limit)
    @values = (1..limit).to_a
  end

  def squares
    @values.map { |value| value * value }
  end

  def total
    squares.sum
  end
end

calc = Squares.new(10)
expected = [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
raise "unexpected squares: #{calc.squares.inspect}" unless calc.squares == expected
raise "unexpected total: #{calc.total}" unless calc.total == 385

File.write("roundtrip.txt", calc.squares.join(","))
raise "roundtrip file is empty" unless File.size("roundtrip.txt") > 0

read_back = File.read("roundtrip.txt").split(",").map { |item| Integer(item, 10) }
raise "read-back mismatch: #{read_back.inspect}" unless read_back == expected

File.write("roundtrip.txt", "openEuler-ruby-roundtrip")
overwritten = File.read("roundtrip.txt")
unless overwritten == "openEuler-ruby-roundtrip"
  raise "overwrite check failed: #{overwritten.inspect}"
end

puts "CORE_OK total=#{calc.total}"
RUBY

    if ! run_ruby_script "probe.rb" "${expected}" "core function"; then
        return 1
    fi

    if [[ ! -s "${WORKDIR}/roundtrip.txt" ]]; then
        printf 'FAIL: script data file missing or empty: %s\n' \
            "${WORKDIR}/roundtrip.txt" >&2
        return 1
    fi

    printf 'PASS: core function: %s\n' "${expected}"
}

test_native_extensions() {
    local expected="DEPS_OK openssl=1 zlib=1 yaml=1 json=1 socket=1 fiddle=1"

    cat > "${WORKDIR}/deps.rb" <<'RUBY'
require "openssl"
require "zlib"
require "yaml"
require "json"
require "socket"
require "digest"
require "fiddle"

sha = OpenSSL::Digest::SHA256.hexdigest("abc")
unless sha == "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
  raise "openssl digest mismatch: #{sha}"
end

deflated = Zlib::Deflate.deflate("ruby-zlib")
inflated = Zlib::Inflate.inflate(deflated)
raise "zlib roundtrip mismatch: #{inflated.inspect}" unless inflated == "ruby-zlib"

loaded = YAML.safe_load(YAML.dump({ "image" => "ruby", "series" => "4.0" }))
unless loaded == { "image" => "ruby", "series" => "4.0" }
  raise "yaml roundtrip mismatch: #{loaded.inspect}"
end

raise "json parse mismatch" unless JSON.parse('{"k":42}')["k"] == 42

server = TCPServer.new("127.0.0.1", 0)
port = server.addr[1]
server.close
raise "socket bind returned no port" unless port.is_a?(Integer) && port > 0

getpid = Fiddle::Function.new(
  Fiddle::Handle::DEFAULT["getpid"],
  [],
  Fiddle::TYPE_INT,
)
raise "fiddle getpid failed" unless getpid.call > 0

puts "DEPS_OK openssl=1 zlib=1 yaml=1 json=1 socket=1 fiddle=1"
RUBY

    if ! run_ruby_script "deps.rb" "${expected}" "native extensions"; then
        return 1
    fi

    printf 'PASS: native extensions: %s\n' "${expected}"
}

test_error_exit() {
    local output rc

    if output="$("${BINARY}" -e 'exit 42' 2>&1)"; then
        rc=0
    else
        rc=$?
    fi
    if [[ "${rc}" -ne 42 ]]; then
        printf 'FAIL: "exit 42" propagated exit status %s, expected 42: %s\n' \
            "${rc}" "${output}" >&2
        return 1
    fi

    if output="$("${BINARY}" -e 'raise "intentional failure"' 2>&1)"; then
        rc=0
    else
        rc=$?
    fi
    if [[ "${rc}" -eq 0 ]]; then
        printf 'FAIL: failing script exited 0, expected non-zero\n' >&2
        return 1
    fi
    if [[ "${output}" != *"intentional failure"* ]]; then
        printf 'FAIL: error message not reported: <%s>\n' "${output}" >&2
        return 1
    fi

    printf 'PASS: error exit status propagation (raise rc=%s, exit 42 rc=42)\n' \
        "${rc}"
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_core_function; then
        failures=$((failures + 1))
    fi
    if ! test_native_extensions; then
        failures=$((failures + 1))
    fi
    if ! test_error_exit; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
