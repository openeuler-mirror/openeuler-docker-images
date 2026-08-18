#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/moose-test.XXXXXX")"
trap 'rm -rf "${WORKDIR}"' EXIT

CXX="g++"
CXXFLAGS=(-std=c++20 -O2 -pthread -I/usr/local/include)

build_probe() {
    local src="$1" bin="$2"
    "${CXX}" "${CXXFLAGS[@]}" "${src}" -o "${bin}"
}

test_version() {
    local src="$WORKDIR/version_check.cpp"
    local bin="$WORKDIR/version_check"
    local output rc

    if ! command -v g++ >/dev/null 2>&1; then
        printf 'FAIL: g++ (gcc-c++) not found in runtime image\n' >&2
        return 1
    fi

    cat > "${src}" <<'EOF'
#include <taskflow/taskflow.hpp>
#include <iostream>

int main() {
  std::cout << tf::version() << std::endl;
  return 0;
}
EOF

    if ! build_probe "${src}" "${bin}"; then
        printf 'FAIL: failed to compile Taskflow version probe with g++ (see output above)\n' >&2
        return 1
    fi

    if ! output="$("${bin}")"; then
        rc=$?
        printf 'FAIL: Taskflow version probe exited %s\n' "${rc}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${output}"
}

test_task_graph() {
    local src="$WORKDIR/graph_check.cpp"
    local bin="$WORKDIR/graph_check"
    local output rc expected="A B C D"

    cat > "${src}" <<'EOF'
#include <taskflow/taskflow.hpp>
#include <chrono>
#include <future>
#include <iostream>
#include <string>
#include <vector>

int main() {
  std::vector<std::string> order;

  tf::Executor executor(4);
  tf::Taskflow taskflow;

  auto A = taskflow.emplace([&]() { order.push_back("A"); });
  auto B = taskflow.emplace([&]() { order.push_back("B"); });
  auto C = taskflow.emplace([&]() { order.push_back("C"); });
  auto D = taskflow.emplace([&]() { order.push_back("D"); });

  A.precede(B);
  B.precede(C);
  C.precede(D);

  auto future = executor.run(taskflow);
  if (future.wait_for(std::chrono::seconds(30)) == std::future_status::timeout) {
    std::cerr << "TIMEOUT: task graph did not complete within 30s" << std::endl;
    return 2;
  }

  for (const auto& t : order) {
    std::cout << t << ' ';
  }
  std::cout << std::endl;
  return 0;
}
EOF

    if ! build_probe "${src}" "${bin}"; then
        printf 'FAIL: failed to compile Taskflow graph probe with g++ (see output above)\n' >&2
        return 1
    fi

    if ! output="$("${bin}")"; then
        rc=$?
        printf 'FAIL: Taskflow graph probe exited %s\n' "${rc}" >&2
        return 1
    fi

    output="${output%"${output##*[![:space:]]}"}"

    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: graph execution mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    printf 'PASS: task graph dependency chain executed in order\n'
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_task_graph; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
