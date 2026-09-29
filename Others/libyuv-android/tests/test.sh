#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# libyuv-android ships the libyuv C++ library built from the pinned upstream
# archive. The image installs:
#   /usr/local/include/libyuv.h        (main umbrella header)
#   /usr/local/include/libyuv/*.h      (all module headers, incl. version.h)
#   /usr/local/lib/libyuv.so           (shared library, cached by ldconfig)
#   /usr/local/lib/libyuv.a            (static library)
#   /usr/local/bin/yuvconvert          (upstream conversion tool)
#   /usr/local/share/licenses/libyuv/{LICENSE,PATENTS}
# There is no libyuv-android binary that prints the 0.44.0 release string, so
# the exact release identity is verified through the byte-for-byte installed
# libyuv header fingerprint plus the LIBYUV_VERSION reported by the library,
# both of which are pinned by the libyuv-android source tree.

PREFIX="/usr/local"
INCLUDE_DIR="${PREFIX}/include"
LIB_DIR="${PREFIX}/lib"
MAIN_HEADER="${INCLUDE_DIR}/libyuv.h"
VERSION_HEADER="${INCLUDE_DIR}/libyuv/version.h"
LICENSE_FILE="${PREFIX}/share/licenses/libyuv/LICENSE"
PATENTS_FILE="${PREFIX}/share/licenses/libyuv/PATENTS"
YUVCONVERT_BIN="${PREFIX}/bin/yuvconvert"
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

require_command() {
    local tool="$1"
    if ! command -v "${tool}" >/dev/null 2>&1; then
        fail "required runtime command not found: ${tool}"
        return 1
    fi
}

# Exact release identity, pinned by the libyuv-android v0.44.0 source tree.
# Prints "<LIBYUV_VERSION> <sha256 of core/deps/libyuv/include/libyuv/version.h>".
# Extend this table when a new libyuv-android release is added; never loosen
# the comparison to a prefix/substring match.
expected_release() {
    case "$1" in
        0.44.0)
            printf '%s %s\n' \
                "1957" \
                "8ed05635cce7f991a0e018725b6b753483e464a5cf074fc1e7657055ea619d5d"
            ;;
        *)
            return 1
            ;;
    esac
}

test_install_layout() {
    local file

    for file in "${MAIN_HEADER}" "${VERSION_HEADER}" \
                "${LIB_DIR}/libyuv.so" "${LIB_DIR}/libyuv.a" \
                "${LICENSE_FILE}" "${PATENTS_FILE}"; do
        if [[ ! -f "${file}" ]]; then
            fail "installed artifact missing: ${file}"
            return 1
        fi
    done

    if [[ ! -x "${YUVCONVERT_BIN}" ]]; then
        fail "yuvconvert tool missing or not executable: ${YUVCONVERT_BIN}"
        return 1
    fi

    printf 'PASS: libyuv headers, libraries, licenses and yuvconvert installed\n'
}

test_version() {
    local info expected_yuv expected_sha actual_sha output rc

    if ! info="$(expected_release "${EXPECTED_VERSION}")"; then
        fail "no verified release identity for libyuv-android <${EXPECTED_VERSION}>"
        return 1
    fi
    expected_yuv="${info%% *}"
    expected_sha="${info##* }"

    if [[ ! -f "${VERSION_HEADER}" ]]; then
        fail "version header missing: ${VERSION_HEADER}"
        return 1
    fi

    actual_sha="$(sha256sum "${VERSION_HEADER}")"
    actual_sha="${actual_sha%% *}"
    if [[ "${actual_sha}" != "${expected_sha}" ]]; then
        fail "installed version.h fingerprint mismatch: expected=<${expected_sha}> actual=<${actual_sha}>"
        return 1
    fi

    cat > "${WORKDIR}/version_probe.cpp" <<'EOF'
#include <libyuv/version.h>
#include <cstdio>
int main() {
    std::printf("%d\n", LIBYUV_VERSION);
    return 0;
}
EOF

    if ! output="$(g++ -std=c++14 -I"${INCLUDE_DIR}" \
            "${WORKDIR}/version_probe.cpp" -L"${LIB_DIR}" \
            -Wl,-rpath,"${LIB_DIR}" -lyuv \
            -o "${WORKDIR}/version_probe" 2>&1)"; then
        rc=$?
        fail "g++ compile/link of version probe exited ${rc}: ${output}"
        return 1
    fi

    if ! output="$("${WORKDIR}/version_probe" 2>&1)"; then
        rc=$?
        fail "version probe exited ${rc}: ${output}"
        return 1
    fi

    if [[ "${output}" != "${expected_yuv}" ]]; then
        fail "libyuv version mismatch: expected=<${expected_yuv}> actual=<${output}>"
        return 1
    fi

    printf 'PASS: exact libyuv version %s for libyuv-android %s\n' \
        "${output}" "${EXPECTED_VERSION}"
}

test_core_function() {
    local output rc

    cat > "${WORKDIR}/core_probe.cpp" <<'EOF'
#include <libyuv.h>
#include <cstdint>
#include <cstdio>
#include <vector>

static int failures = 0;

static void check(bool ok, const char* what) {
    if (!ok) {
        std::printf("FAIL: %s\n", what);
        ++failures;
    }
}

static bool nv12_to_rgb(int w, int h, uint8_t y_value,
                        std::vector<uint8_t>& out) {
    std::vector<uint8_t> y(w * h, y_value);
    std::vector<uint8_t> uv(w * h / 2, 128);
    out.assign(w * h * 3, 0);
    int rc = libyuv::NV12ToRGB24(y.data(), w, uv.data(), w,
                                 out.data(), w * 3, w, h);
    return rc == 0;
}

static bool all_equal_to(const std::vector<uint8_t>& data, uint8_t value) {
    for (size_t i = 0; i < data.size(); ++i) {
        if (data[i] != value) {
            return false;
        }
    }
    return true;
}

int main() {
    const int w = 16;
    const int h = 16;
    std::vector<uint8_t> black_simd;
    std::vector<uint8_t> white_simd;
    std::vector<uint8_t> black_c;
    std::vector<uint8_t> white_c;

    // BT.601 limited range black: Y=16, U=V=128 must map to RGB 0,0,0.
    // BT.601 limited range white: Y=235, U=V=128 must map to RGB 255,255,255.
    check(nv12_to_rgb(w, h, 16, black_simd), "NV12ToRGB24(black) returned non-zero");
    check(nv12_to_rgb(w, h, 235, white_simd), "NV12ToRGB24(white) returned non-zero");
    check(all_equal_to(black_simd, 0), "NV12 black did not convert to RGB 0,0,0");
    check(all_equal_to(white_simd, 255), "NV12 white did not convert to RGB 255,255,255");

    // Force the C reference path (MaskCpuFlags(1) clears all SIMD flags) and
    // require the optimized result to match it exactly on every architecture.
    libyuv::MaskCpuFlags(1);
    check(nv12_to_rgb(w, h, 16, black_c), "NV12ToRGB24(black,C) returned non-zero");
    check(nv12_to_rgb(w, h, 235, white_c), "NV12ToRGB24(white,C) returned non-zero");
    check(black_simd == black_c, "NV12 black optimized result differs from C reference");
    check(white_simd == white_c, "NV12 white optimized result differs from C reference");
    check(all_equal_to(black_c, 0), "NV12 black C reference not RGB 0,0,0");
    check(all_equal_to(white_c, 255), "NV12 white C reference not RGB 255,255,255");

    // RGB24 -> ARGB -> RGB24 is a lossless format conversion; bytes must match.
    {
        const int rw = 8;
        const int rh = 4;
        std::vector<uint8_t> src(rw * rh * 3);
        for (size_t i = 0; i < src.size(); ++i) {
            src[i] = static_cast<uint8_t>((i * 37 + 11) & 0xFF);
        }
        std::vector<uint8_t> argb(rw * rh * 4, 0);
        std::vector<uint8_t> back(rw * rh * 3, 0);
        int rc1 = libyuv::RGB24ToARGB(src.data(), rw * 3, argb.data(), rw * 4,
                                      rw, rh);
        int rc2 = libyuv::ARGBToRGB24(argb.data(), rw * 4, back.data(), rw * 3,
                                      rw, rh);
        check(rc1 == 0, "RGB24ToARGB returned non-zero");
        check(rc2 == 0, "ARGBToRGB24 returned non-zero");
        check(back == src, "RGB24 round trip through ARGB changed bytes");
    }

    if (failures != 0) {
        std::printf("CORE_FAILED: %d\n", failures);
        return 1;
    }
    std::printf("CORE_OK\n");
    return 0;
}
EOF

    if ! output="$(g++ -std=c++14 -I"${INCLUDE_DIR}" \
            "${WORKDIR}/core_probe.cpp" -L"${LIB_DIR}" \
            -Wl,-rpath,"${LIB_DIR}" -lyuv \
            -o "${WORKDIR}/core_probe" 2>&1)"; then
        rc=$?
        fail "g++ compile/link of core probe exited ${rc}: ${output}"
        return 1
    fi

    if ! output="$("${WORKDIR}/core_probe" 2>&1)"; then
        rc=$?
        fail "core probe exited ${rc}: ${output}"
        return 1
    fi

    if [[ "${output}" != "CORE_OK" ]]; then
        fail "core probe result mismatch: expected=<CORE_OK> actual=<${output}>"
        return 1
    fi

    printf 'PASS: NV12->RGB24 conversion and RGB24->ARGB->RGB24 round trip\n'
}

main() {
    local failures=0

    for tool in g++ sha256sum mktemp; do
        if ! require_command "${tool}"; then
            failures=$((failures + 1))
        fi
    done
    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    WORKDIR="$(mktemp -d /tmp/libyuv_android_test.XXXXXX)" || {
        fail "could not create temporary working directory"
        return 1
    }

    if ! test_install_layout; then
        failures=$((failures + 1))
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
