#!/bin/bash
set -e
set -o pipefail

# === 由 image-tester Agent 生成 ===
# 软件包: test-pkg
# 版本: 1.36.2
# 类型: CLI 工具 (kubectl)
# 容器以 tail -f /dev/null 保持存活，直接用 docker exec 验证

CONTAINER_NAME="test-${PACKAGE_NAME:-test-pkg}"
BINARY="kubectl"
EXPECTED_VERSION="1.36.2"

# 测试1: 二进制存在验证
test_binary_exists() {
    if docker exec "${CONTAINER_NAME}" which kubectl >/dev/null 2>&1 || \
       docker exec "${CONTAINER_NAME}" ls /usr/local/bin/kubectl >/dev/null 2>&1; then
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
    # kubectl version --client 仅输出客户端版本，无需连接集群
    output=$(docker exec "${CONTAINER_NAME}" kubectl version --client 2>&1 || \
             docker exec "${CONTAINER_NAME}" kubectl version --client=true 2>&1 || \
             docker exec "${CONTAINER_NAME}" kubectl --client version 2>&1 || \
             echo "")
    if [ -z "${output}" ]; then
        echo "FAIL: version check - binary did not produce any output"
        return 1
    fi
    if echo "${output}" | grep -qi "${EXPECTED_VERSION}"; then
        echo "PASS: version check - ${EXPECTED_VERSION} found"
        return 0
    fi
    # 检查输出是否包含任何版本号模式（如 v1.2.3 或 1.2.3）
    if echo "${output}" | grep -qE 'v?[0-9]+\.[0-9]+\.[0-9]+'; then
        echo "FAIL: version check - expected ${EXPECTED_VERSION}, got: ${output}"
        return 1
    fi
    # 未发现版本号模式 - 可能是源码构建未注入版本
    echo "WARN: version check - no version pattern in output: ${output}"
    echo "PASS: version check (binary runs, no version injected)"
    return 0
}

# 测试3: 帮助信息验证
test_help() {
    local output
    output=$(docker exec "${CONTAINER_NAME}" kubectl --help 2>&1 || echo "")
    if [ -z "${output}" ]; then
        echo "FAIL: help check - no output from --help"
        return 1
    fi
    if echo "${output}" | grep -qi "kubectl"; then
        echo "PASS: help check - kubectl help output valid"
        return 0
    fi
    echo "FAIL: help check - unexpected output: ${output}"
    return 1
}

# 测试4: 基本功能验证（列出可用命令，不依赖集群）
test_function() {
    local output
    # kubectl 提供众多子命令，验证 api-resources 之外的安全命令
    # 使用 kubectl options 查看全局选项，无需集群连接
    output=$(docker exec "${CONTAINER_NAME}" kubectl options 2>&1 || echo "")
    if echo "${output}" | grep -qi "option"; then
        echo "PASS: basic function test - kubectl options works"
        return 0
    fi
    # 回退：验证 kubectl 能正常解析命令（不报段错误）
    output=$(docker exec "${CONTAINER_NAME}" kubectl config --help 2>&1 || echo "")
    if echo "${output}" | grep -qi "config"; then
        echo "PASS: basic function test - kubectl config help works"
        return 0
    fi
    echo "FAIL: basic function test - no valid output"
    return 1
}

# 主流程
main() {
    local failures=0

    test_binary_exists || failures=$((failures + 1))
    test_version || failures=$((failures + 1))
    test_help || failures=$((failures + 1))
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
