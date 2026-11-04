#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

BINARY="/usr/bin/suricata"
WORKDIR=""

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_binary_and_version() {
    local output rc reported

    if [[ ! -x "${BINARY}" ]]; then
        printf 'FAIL: suricata binary not found or not executable: %s\n' \
            "${BINARY}" >&2
        return 1
    fi

    if output="$("${BINARY}" -V 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: suricata -V exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" =~ Suricata\ version\ ([0-9]+\.[0-9]+\.[0-9]+) ]]; then
        reported="${BASH_REMATCH[1]}"
    else
        printf 'FAIL: cannot parse version from suricata -V output: <%s>\n' \
            "${output}" >&2
        return 1
    fi

    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${reported}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${reported}"
}

test_build_info() {
    local output rc

    if output="$("${BINARY}" --build-info 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: suricata --build-info exited %s:\n%s\n' \
            "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != *"Suricata Configuration:"* ]]; then
        printf 'FAIL: build info has no configuration section:\n%s\n' \
            "${output}" >&2
        return 1
    fi

    # The Dockerfile builds with --enable-nfqueue and Rust support is mandatory
    # since Suricata 7, so both features must be reported by the shipped binary.
    if ! printf '%s\n' "${output}" | grep -Eq 'NFQueue support:[[:space:]]+yes'; then
        printf 'FAIL: build info does not report NFQueue support:\n%s\n' \
            "${output}" >&2
        return 1
    fi

    # Suricata 8 lists Rust support as the RUST compile-time feature on the
    # "Features:" line; older releases advertise it via "Rust support: yes".
    if ! printf '%s\n' "${output}" | \
        grep -Eq 'Rust support:[[:space:]]+yes|(^|[[:space:]])RUST([[:space:]]|$)'; then
        printf 'FAIL: build info does not report Rust support:\n%s\n' \
            "${output}" >&2
        return 1
    fi

    printf 'PASS: build info reports NFQueue and Rust support\n'
}

test_config_validation() {
    local output rc args=()

    # The build installs the configuration via `make install-conf` under the
    # compiled-in sysconfdir; some builds also ship a copy under /etc/suricata.
    if [[ -f /etc/suricata/suricata.yaml ]]; then
        args=(-c /etc/suricata/suricata.yaml)
    elif [[ -f /usr/etc/suricata/suricata.yaml ]]; then
        args=(-c /usr/etc/suricata/suricata.yaml)
    fi

    if output="$("${BINARY}" -T "${args[@]}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: suricata -T exited %s:\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != *"Configuration provided was successfully loaded"* ]]; then
        printf 'FAIL: configuration test did not report success:\n%s\n' \
            "${output}" >&2
        return 1
    fi

    printf 'PASS: suricata -T loaded and validated the shipped configuration\n'
}

test_alert_on_pcap() {
    local pcap="${WORKDIR}/alert.pcap"
    local rules="${WORKDIR}/test.rules"
    local logs="${WORKDIR}/logs"
    local output rc

    mkdir -p "${logs}"

    # Classic pcap file, little-endian, Ethernet link type, one packet:
    # 10.0.0.1:12345 -> 10.0.0.2:80 carrying "GET /attack HTTP/1.1".
    # 24-byte file header
    printf '\xd4\xc3\xb2\xa1\x02\x00\x04\x00' > "${pcap}"
    printf '\x00\x00\x00\x00\x00\x00\x00\x00' >> "${pcap}"
    printf '\xff\xff\x00\x00\x01\x00\x00\x00' >> "${pcap}"
    # 16-byte record header, little-endian: timestamp 0, captured/original
    # length 90 bytes (0x5a) must be stored as 5a 00 00 00, not 00 00 00 5a.
    printf '\x00\x00\x00\x00\x00\x00\x00\x00' >> "${pcap}"
    printf '\x5a\x00\x00\x00\x5a\x00\x00\x00' >> "${pcap}"
    # Ethernet header
    printf '\x00\x11\x22\x33\x44\x55\x66\x77\x88\x99\xaa\xbb\x08\x00' >> "${pcap}"
    # IPv4 header: total length 76, TCP, TTL 64
    printf '\x45\x00\x00\x4c\x00\x01\x40\x00\x40\x06\x00\x00' >> "${pcap}"
    printf '\x0a\x00\x00\x01\x0a\x00\x00\x02' >> "${pcap}"
    # TCP header: source 12345, destination 80
    printf '\x30\x39\x00\x50\x00\x00\x00\x01\x00\x00\x00\x00' >> "${pcap}"
    printf '\x50\x18\x20\x00\x00\x00\x00\x00' >> "${pcap}"
    # 36-byte payload matched by the "attack" rule content
    printf 'GET /attack HTTP/1.1\r\nHost: test\r\n\r\n' >> "${pcap}"

    cat > "${rules}" <<'EOF'
alert tcp any any -> any any (msg:"SURICATA_TEST_ALERT"; content:"attack"; sid:1000001; rev:1;)
EOF

    # -k none disables checksum validation so the crafted frame needs no valid
    # IP/TCP checksums; the point is exercising the real detection path.
    if output="$("${BINARY}" -r "${pcap}" -S "${rules}" -l "${logs}" -k none 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: suricata pcap run exited %s:\n%s\n' \
            "${rc}" "${output}" >&2
        return 1
    fi

    if [[ ! -s "${logs}/fast.log" ]]; then
        printf 'FAIL: fast.log was not produced in %s:\n%s\n' \
            "${logs}" "${output}" >&2
        return 1
    fi

    if ! grep -q 'SURICATA_TEST_ALERT' "${logs}/fast.log"; then
        printf 'FAIL: expected alert missing from fast.log:\n%s\n' \
            "$(cat "${logs}/fast.log")" >&2
        return 1
    fi

    printf 'PASS: rule matched the crafted pcap and raised a fast.log alert\n'
}

main() {
    local failures=0

    WORKDIR="$(mktemp -d)"
    if [[ ! -d "${WORKDIR}" ]]; then
        printf 'FAIL: cannot create temporary working directory\n' >&2
        return 1
    fi

    if ! test_binary_and_version; then
        failures=$((failures + 1))
    fi
    if ! test_build_info; then
        failures=$((failures + 1))
    fi
    if ! test_config_validation; then
        failures=$((failures + 1))
    fi
    if ! test_alert_on_pcap; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
