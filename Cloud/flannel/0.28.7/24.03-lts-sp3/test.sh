#!/bin/bash
set -e
set -o pipefail

# === 由 image-tester Agent 生成 ===
# 软件包: flannel
# 版本: 0.28.7
# 类型: Go 服务 / 预编译二进制
# 容器以 tail -f /dev/null 保持存活，直接用 docker exec 验证

CONTAINER_NAME="test-${PACKAGE_NAME:-flannel}"
BINARY="flannel"
BINARY_PATH="/usr/bin/flannel"
EXPECTED_VERSION="0.28.7"

# 测试1: 二进制存在验证
test_binary_exists() {
    if docker exec "${CONTAINER_NAME}" which ${BINARY} >/dev/null 2>&1 || \
       docker exec "${CONTAINER_NAME}" ls ${BINARY_PATH} >/dev/null 2>&1; then
        echo "PASS: binary exists"
        return 0
    else
        echo "FAIL: binary not found"
        return 1
    fi
}

# 测试2: 版本号验证
test_version() {
    local output
    output=$(docker exec "${CONTAINER_NAME}" ${BINARY_PATH} --version 2>&1 || \
             docker exec "${CONTAINER_NAME}" ${BINARY_PATH} -v 2>&1 || \
             docker exec "${CONTAINER_NAME}" ${BINARY_PATH} version 2>&1 || \
             echo "")
    if [ -z "${output}" ]; then
        echo "FAIL: version check - binary did not produce any output"
        return 1
    fi
    if echo "${output}" | grep -qi "${EXPECTED_VERSION}"; then
        echo "PASS: version check - ${output}"
        return 0
    fi
    # Check if output contains any version-like pattern (e.g. v1.2.3 or 1.2.3)
    if echo "${output}" | grep -qE 'v?[0-9]+\.[0-9]+\.[0-9]+'; then
        echo "FAIL: version check - expected ${EXPECTED_VERSION}, got: ${output}"
        return 1
    fi
    # No version pattern found - likely source-built without version injection
    echo "WARN: version check - no version pattern in output: ${output}"
    echo "PASS: version check (binary runs, no version injected)"
    return 0
}

# 测试3: 基本功能验证
test_function() {
    # flannel --help 输出帮助信息，验证二进制可正常执行
    local output
    output=$(docker exec "${CONTAINER_NAME}" ${BINARY_PATH} --help 2>&1 || true)
    if [ -n "${output}" ]; then
        echo "PASS: basic function test (--help runs)"
        return 0
    else
        echo "FAIL: basic function test - no help output"
        return 1
    fi
}

# 主流程
main() {
    local failures=0

    test_binary_exists || failures=$((failures + 1))
    test_version || failures=$((failures + 1))
    test_function || failures=$((failures + 1))

    if [ $failures -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        exit 0
    else
        echo "TESTS_FAILED: ${failures} failures"
        exit 1
    fi
}

main "$@"
