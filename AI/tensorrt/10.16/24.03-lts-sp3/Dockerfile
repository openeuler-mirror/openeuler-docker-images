ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TENSORRT_VERSION=10.16

RUN dnf install -y python3-pip && \
    dnf clean all

RUN pip install --no-cache-dir \
        -i https://pypi.tuna.tsinghua.edu.cn/simple \
        "tensorrt>=${TENSORRT_VERSION}.0,<${TENSORRT_VERSION}.1"
