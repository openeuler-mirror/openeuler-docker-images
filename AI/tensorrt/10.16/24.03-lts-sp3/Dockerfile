ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=10.16

RUN dnf install -y python3-pip && \
    dnf clean all

RUN pip install --no-cache-dir \
        -i https://pypi.tuna.tsinghua.edu.cn/simple \
        "tensorrt>=${VERSION}.0,<${VERSION}.1"
