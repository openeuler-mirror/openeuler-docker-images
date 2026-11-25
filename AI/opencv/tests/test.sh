#!/bin/bash
# KunpengTest functional test for opencv (version check).
#
# CI executes this file inside the image under test with --entrypoint bash and
# the script directory mounted read-only at /tmp/eptest. Injected env vars:
# EXPECTED_VERSION (image version dir name), DOCKER_NAMESPACE, DOCKER_PACKAGE,
# DOCKER_TAG, DOCKER_IMAGE.
#
# OpenCV is built from source and installed under /usr/local/opencv-cann. The
# native binary opencv_version prints exactly CV_VERSION (e.g. "5.1.0") and
# does not require an Ascend NPU, unlike "import cv2" (which queries the local
# SoC and aborts when no NPU device is present). The version is therefore
# validated through opencv_version and compared exactly with EXPECTED_VERSION.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

APP_NAME="opencv"

find_opencv_version() {
    local p
    command -v opencv_version 2>/dev/null && return 0
    for p in /usr/local/opencv-cann/bin/opencv_version \
             /usr/local/bin/opencv_version /usr/bin/opencv_version; do
        if [ -x "${p}" ]; then
            printf '%s\n' "${p}"
            return 0
        fi
    done
    for p in /usr/local/*/bin/opencv_version; do
        if [ -x "${p}" ]; then
            printf '%s\n' "${p}"
            return 0
        fi
    done
    return 1
}

test_version() {
    local bin out
    bin="$(find_opencv_version 2>/dev/null || true)"
    if [ -z "${bin}" ]; then
        printf 'FAIL: opencv_version binary not found\n'
        return 1
    fi
    out="$( "${bin}" 2>&1 )"
    out="$(printf '%s' "${out}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    if [ "${out}" = "${EXPECTED_VERSION}" ]; then
        printf 'PASS: %s reports exact version %s\n' "${APP_NAME}" "${out}"
        return 0
    fi
    printf 'FAIL: expected version %s, got: %s\n' "${EXPECTED_VERSION}" "${out}"
    return 1
}

main() {
    local failures=0
    test_version || failures=$((failures + 1))
    if [ "${failures}" -eq 0 ]; then
        printf 'ALL_TESTS_PASSED\n'
        return 0
    fi
    printf 'TESTS_FAILED: %s failure(s)\n' "${failures}"
    return 1
}

main "$@"
