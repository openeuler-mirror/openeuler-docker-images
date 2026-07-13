#!/bin/bash
set -e

#VERSION="4.3.5_bp2_hf1"
VERSION=${1,,}
TARGETARCH=$2
OUTPUTDIR=$3
ARCH=""
if [ "$TARGETARCH" = "amd64" ]; then
    ARCH="x86_64";
elif [ "$TARGETARCH" = "arm64" ]; then
    ARCH="aarch64";
fi;
BASE_URL="https://obbusiness-private.oss-cn-shanghai.aliyuncs.com/download-center/opensource/oceanbase-all-in-one/8/${ARCH}"
for day in {0..60}; do
    DATE=$(date -d "today - $day days" +"%Y%m%d")
    URL="${BASE_URL}/oceanbase-all-in-one-${VERSION}_${DATE}.el8.${ARCH}.tar.gz"
    if curl --output /dev/null --silent --head --fail "$URL"; then
        echo "[INFO] 正在下载文件: ${URL}"
        curl -fSL -o $OUTPUTDIR ${URL}
        exit 0
    fi
done
echo "[ERROR] 无法获取下载链接，请手动检查！" >&2
exit 1