#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

INCLUDE_DIR="/usr/local/include/taskflow"
WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT

check_compiler() {
    if ! command -v g++ >/dev/null 2>&1; then
        printf 'FAIL: g++ not found in PATH\n' >&2
        return 1
    fi
    printf 'PASS: g++ compiler available: %s\n' "$(command -v g++)"
}

check_headers() {
    if [[ ! -f "${INCLUDE_DIR}/taskflow.hpp" ]]; then
        printf 'FAIL: header not found: %s\n' "${INCLUDE_DIR}/taskflow.hpp" >&2
        return 1
    fi
    if [[ ! -f "${INCLUDE_DIR}/core/executor.hpp" ]]; then
        printf 'FAIL: header not found: %s\n' "${INCLUDE_DIR}/core/executor.hpp" >&2
        return 1
    fi
    printf 'PASS: taskflow headers installed under %s\n' "${INCLUDE_DIR}"
}

test_version() {
    local output rc

    cat > "${WORKDIR}/version_test.cpp" <<'EOF'
#include <taskflow/taskflow.hpp>
#include <cstdio>

int main() {
  std::printf("%s\n", tf::version());
  return 0;
}
EOF

    if ! g++ -std=c++20 -O2 -pthread -I/usr/local/include \
        "${WORKDIR}/version_test.cpp" -o "${WORKDIR}/version_test" \
        2>"${WORKDIR}/compile.err"; then
        printf 'FAIL: could not compile version_test.cpp:\n' >&2
        cat "${WORKDIR}/compile.err" >&2
        return 1
    fi

    if ! output="$("${WORKDIR}/version_test" 2>&1)"; then
        rc=$?
        printf 'FAIL: version test binary exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${output}"
}

test_core_function() {
    local output rc

    cat > "${WORKDIR}/func_test.cpp" <<'EOF'
#include <taskflow/taskflow.hpp>
#include <atomic>
#include <cstdio>

int main() {
  std::atomic<int> order{0};
  std::atomic<int> violations{0};

  tf::Executor executor;
  tf::Taskflow taskflow;

  auto [A, B, C, D] = taskflow.emplace(
    [&] () { int o = order.fetch_add(1); if (o != 0) ++violations; },
    [&] () { int o = order.fetch_add(1); if (o < 1) ++violations; },
    [&] () { int o = order.fetch_add(1); if (o < 1) ++violations; },
    [&] () { int o = order.fetch_add(1); if (o < 3) ++violations; }
  );

  A.precede(B, C);
  D.succeed(B, C);

  executor.run(taskflow).wait();

  if (violations.load() != 0 || order.load() != 4) {
    std::fprintf(stderr, "FAIL: dependency execution invalid: order=%d violations=%d\n",
      order.load(), violations.load());
    return 1;
  }

  std::printf("TF_FUNC_OK\n");
  return 0;
}
EOF

    if ! g++ -std=c++20 -O2 -pthread -I/usr/local/include \
        "${WORKDIR}/func_test.cpp" -o "${WORKDIR}/func_test" \
        2>"${WORKDIR}/compile2.err"; then
        printf 'FAIL: could not compile func_test.cpp:\n' >&2
        cat "${WORKDIR}/compile2.err" >&2
        return 1
    fi

    if ! output="$("${WORKDIR}/func_test" 2>&1)"; then
        rc=$?
        printf 'FAIL: func test binary exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "TF_FUNC_OK" ]]; then
        printf 'FAIL: unexpected func test output: %s\n' "${output}" >&2
        return 1
    fi

    printf 'PASS: task dependency graph executed correctly\n'
}

main() {
    local failures=0

    if ! check_compiler; then
        failures=$((failures + 1))
    fi
    if ! check_headers; then
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
