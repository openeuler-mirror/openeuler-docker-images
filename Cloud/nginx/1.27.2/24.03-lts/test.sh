#!/bin/bash
set -e; set -o pipefail
CONTAINER_NAME="${CONTAINER_NAME:-${PACKAGE_NAME:-nginx}-test}"
BINARY="nginx"
test_binary_exists() { docker exec "$CONTAINER_NAME" which "$BINARY" >/dev/null 2>&1 && echo "PASS: binary exists" || { echo "FAIL: binary not found"; return 1; } }
test_version_command() { docker exec "$CONTAINER_NAME" "$BINARY" -v >/dev/null 2>&1 && echo "PASS: version command works: $(docker exec "$CONTAINER_NAME" "$BINARY" -v 2>&1 || true)" || { echo "FAIL: version command failed"; return 1; } }
main() { local f=0; test_binary_exists || f=$((f+1)); test_version_command || f=$((f+1)); [ "$f" -eq 0 ] && echo "ALL_TESTS_PASSED" && exit 0 || { echo "TESTS_FAILED: $f failures"; exit 1; } }
main "$@"
