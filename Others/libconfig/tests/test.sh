#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

PREFIX="/usr/local"
INCLUDE_DIR="${PREFIX}/include"
LIB_DIR="${PREFIX}/lib"
PKGCONFIG_DIR="${LIB_DIR}/pkgconfig"
LICENSE_FILE="${PREFIX}/share/licenses/libconfig/COPYING.LIB"
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

pkg_config() {
    PKG_CONFIG_PATH="${PKGCONFIG_DIR}" pkg-config "$@"
}

test_version() {
    local module="$1" actual

    if ! actual="$(pkg_config --modversion "${module}" 2>&1)"; then
        fail "pkg-config --modversion ${module} failed: ${actual}"
        return 1
    fi

    if [[ "${actual}" != "${EXPECTED_VERSION}" ]]; then
        fail "pkg-config ${module} version mismatch: expected=<${EXPECTED_VERSION}> actual=<${actual}>"
        return 1
    fi

    printf 'PASS: pkg-config reports %s %s\n' "${module}" "${actual}"
}

test_installed_files() {
    local header

    for header in libconfig.h libconfig.h++; do
        if [[ ! -f "${INCLUDE_DIR}/${header}" ]]; then
            fail "expected header missing: ${INCLUDE_DIR}/${header}"
            return 1
        fi
    done

    if [[ ! -f "${LICENSE_FILE}" ]]; then
        fail "license file missing: ${LICENSE_FILE}"
        return 1
    fi

    if ! ls "${LIB_DIR}"/libconfig.so* >/dev/null 2>&1; then
        fail "libconfig shared library missing under ${LIB_DIR}"
        return 1
    fi

    if ! ls "${LIB_DIR}"/libconfig++.so* >/dev/null 2>&1; then
        fail "libconfig++ shared library missing under ${LIB_DIR}"
        return 1
    fi

    printf 'PASS: headers, libraries and license installed\n'
}

test_c_api() {
    local src="${WORKDIR}/cfg_check.c"
    local bin="${WORKDIR}/cfg_check"
    local output rc expected

    cat > "${src}" <<'EOF'
#include <stdio.h>
#include <libconfig.h>

int main(void)
{
  config_t cfg;
  config_setting_t *list;
  const char *name = NULL;
  int port = 0, len = 0, first = 0;
  double ratio = 0.0;

  config_init(&cfg);
  if(! config_read_string(&cfg,
       "name = \"libconfig\"; port = 8080; ratio = 1.5; list = (1, 2, 3);"))
  {
    fprintf(stderr, "parse error: %s\n", config_error_text(&cfg));
    config_destroy(&cfg);
    return 2;
  }

  if(! config_lookup_string(&cfg, "name", &name)) { config_destroy(&cfg); return 3; }
  if(! config_lookup_int(&cfg, "port", &port)) { config_destroy(&cfg); return 4; }
  if(! config_lookup_float(&cfg, "ratio", &ratio)) { config_destroy(&cfg); return 5; }

  list = config_lookup(&cfg, "list");
  if(list == NULL) { config_destroy(&cfg); return 6; }
  len = config_setting_length(list);
  first = config_setting_get_int_elem(list, 0);

  printf("C name=%s port=%d ratio=%.2f len=%d first=%d\n",
         name, port, ratio, len, first);
  config_destroy(&cfg);
  return 0;
}
EOF

    if output="$(gcc $(pkg_config --cflags libconfig) "${src}" -o "${bin}" \
            $(pkg_config --libs libconfig) 2>&1)"; then
        :
    else
        rc=$?
        fail "C compile/link against libconfig failed (exit ${rc}): ${output}"
        return 1
    fi

    if output="$("${bin}" 2>&1)"; then
        :
    else
        rc=$?
        fail "C libconfig probe exited ${rc}: ${output}"
        return 1
    fi

    expected="C name=libconfig port=8080 ratio=1.50 len=3 first=1"
    if [[ "${output}" != "${expected}" ]]; then
        fail "C libconfig result mismatch: expected=<${expected}> actual=<${output}>"
        return 1
    fi

    printf 'PASS: C API parsed and read settings (%s)\n' "${output}"
}

test_cpp_api() {
    local src="${WORKDIR}/cfg_check.cpp"
    local bin="${WORKDIR}/cfg_check_cpp"
    local output rc expected

    cat > "${src}" <<'EOF'
#include <iostream>
#include <string>
#include <libconfig.h++>

using namespace libconfig;

int main()
{
  Config cfg;
  try
  {
    cfg.readString("name = \"libconfig\"; port = 8080;");
  }
  catch(const ParseException &e)
  {
    std::cerr << "parse error: " << e.getError() << std::endl;
    return 2;
  }

  std::string name = cfg.lookup("name");
  int port = cfg.lookup("port");
  std::cout << "CPP name=" << name << " port=" << port << std::endl;
  return 0;
}
EOF

    if output="$(g++ $(pkg_config --cflags libconfig++) "${src}" -o "${bin}" \
            $(pkg_config --libs libconfig++) 2>&1)"; then
        :
    else
        rc=$?
        fail "C++ compile/link against libconfig++ failed (exit ${rc}): ${output}"
        return 1
    fi

    if output="$("${bin}" 2>&1)"; then
        :
    else
        rc=$?
        fail "C++ libconfig probe exited ${rc}: ${output}"
        return 1
    fi

    expected="CPP name=libconfig port=8080"
    if [[ "${output}" != "${expected}" ]]; then
        fail "C++ libconfig result mismatch: expected=<${expected}> actual=<${output}>"
        return 1
    fi

    printf 'PASS: C++ API parsed and read settings (%s)\n' "${output}"
}

main() {
    local failures=0

    for tool in gcc g++ pkg-config mktemp; do
        if ! require_command "${tool}"; then
            failures=$((failures + 1))
        fi
    done
    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    WORKDIR="$(mktemp -d /tmp/libconfig_test.XXXXXX)" || {
        fail "could not create temporary working directory"
        return 1
    }

    if ! test_version libconfig; then
        failures=$((failures + 1))
    fi
    if ! test_version libconfig++; then
        failures=$((failures + 1))
    fi
    if ! test_installed_files; then
        failures=$((failures + 1))
    fi
    if ! test_c_api; then
        failures=$((failures + 1))
    fi
    if ! test_cpp_api; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
