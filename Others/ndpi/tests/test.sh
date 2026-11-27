#!/bin/bash
# KunpengTest functional test for nDPI.
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version dir name), DOCKER_NAMESPACE, DOCKER_PACKAGE,
# DOCKER_TAG, DOCKER_IMAGE.
#
# nDPI is a deep packet inspection (DPI) library. The image builds it from
# source via `git clone -b ${VERSION}` (see Dockerfile) into /nDPI and runs
# `make`, so the example binary lives at /nDPI/example/ndpiReader and the
# bundled test captures live at /nDPI/tests/cfgs/default/pcap/.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

NDPI_DIR="/nDPI"
NDPI_READER="${NDPI_DIR}/example/ndpiReader"
PCAP="${NDPI_DIR}/tests/cfgs/default/pcap/NTPv4.pcap"

# The Dockerfile pins the nDPI release with `git clone -b ${VERSION}` (e.g.
# "-b 6.0" or "-b 6.1-qubitowl"). The checked-out tag may carry a qualifier
# suffix (e.g. "6.1-qubitowl") while the image version directory is the plain
# release ("6.1"). Accept both the exact match and "<version>-<qualifier>".
test_version() {
    local reported
    reported="$(git -C "${NDPI_DIR}" describe --tags --abbrev=0 2>/dev/null || true)"
    reported="$(printf '%s' "${reported}" | tr -d '\n')"
    if [ -z "${reported}" ]; then
        printf 'FAIL: could not determine nDPI release tag from %s\n' "${NDPI_DIR}"
        return 1
    fi
    case "${reported}" in
        "${EXPECTED_VERSION}"|"${EXPECTED_VERSION}"-*)
            printf 'PASS: nDPI release tag %s matches expected version %s\n' "${reported}" "${EXPECTED_VERSION}"
            return 0
            ;;
        *)
            printf 'FAIL: expected nDPI version %s, got %s\n' "${EXPECTED_VERSION}" "${reported}"
            return 1
            ;;
    esac
}

# Core data path: feed a bundled NTP capture to ndpiReader and confirm the DPI
# engine initializes and classifies the flow as NTP.
test_detect_protocol() {
    local out
    if [ ! -x "${NDPI_READER}" ]; then
        printf 'FAIL: ndpiReader not found at %s\n' "${NDPI_READER}"
        return 1
    fi
    if [ ! -f "${PCAP}" ]; then
        printf 'FAIL: bundled test pcap not found at %s\n' "${PCAP}"
        return 1
    fi
    out="$( "${NDPI_READER}" -i "${PCAP}" 2>&1 || true )"
    if printf '%s' "${out}" | grep -q "Using nDPI (" \
       && printf '%s' "${out}" | grep -q "Detected protocols:" \
       && printf '%s' "${out}" | grep -q "NTP"; then
        printf 'PASS: ndpiReader detected NTP protocol from bundled pcap\n'
        return 0
    fi
    printf 'FAIL: ndpiReader did not detect NTP; output: %s\n' \
        "$(printf '%s' "${out}" | tr '\n' ' ' | cut -c1-200)"
    return 1
}

main() {
    local failures=0
    test_version         || failures=$((failures + 1))
    test_detect_protocol || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"
