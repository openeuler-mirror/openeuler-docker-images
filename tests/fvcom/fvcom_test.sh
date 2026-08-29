#!/bin/bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE="${IMAGE:-openeuler/fvcom:5.0.1-oe2403sp4}"
WORKDIR="/tmp/fvcom-smoke-$$"
PASS=0
FAIL=0
CASENAME="smoke_test"

check() {
    local desc="$1"; shift
    if "$@" >/dev/null 2>&1; then
        echo "[PASS] ${desc}"
        PASS=$((PASS + 1))
    else
        echo "[FAIL] ${desc}"
        FAIL=$((FAIL + 1))
    fi
}

check_docker() {
    if ! command -v docker >/dev/null 2>&1; then
        echo "[FAIL] docker 命令不可用"
        exit 1
    fi
    if ! docker image inspect "${IMAGE}" >/dev/null 2>&1; then
        echo "[FAIL] 镜像 ${IMAGE} 不存在，请先构建或拉取"
        exit 1
    fi
}

mkdir -p "${WORKDIR}"

check_docker

echo "=== FVCOM 冒烟测试 (${IMAGE}) ==="

check "fvcom 可执行文件存在" \
    docker run --rm "${IMAGE}" which fvcom

check "fvcom 版本信息输出" \
    docker run --rm "${IMAGE}" fvcom -V

check "fvcom 帮助信息输出" \
    docker run --rm "${IMAGE}" fvcom -h

check "fvcom 生成 namelist" \
    bash -c "docker run --rm -v ${WORKDIR}:/workspace -w /workspace ${IMAGE} fvcom --create_namelist=${CASENAME}"

check "namelist 文件生成" \
    test -f "${WORKDIR}/${CASENAME}_run.nml"

check "mpirun 并行启动" \
    docker run --rm "${IMAGE}" mpirun -np 2 fvcom -h

check "netcdf 动态库可加载" \
    docker run --rm "${IMAGE}" bash -c "ldd /usr/local/bin/fvcom | grep -q netcdf"

rm -rf "${WORKDIR}"

echo ""
echo "结果: ${PASS} 通过, ${FAIL} 失败"
if [ "${FAIL}" -eq 0 ]; then
    echo "FVCOM 冒烟测试全部通过"
    exit 0
else
    echo "FVCOM 冒烟测试存在失败项"
    exit 1
fi
