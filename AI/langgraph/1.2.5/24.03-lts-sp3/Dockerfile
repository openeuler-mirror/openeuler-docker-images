ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE} AS builder

ARG TARGETARCH
ARG VERSION=1.2.5

RUN dnf install -y \
      python3-pip && \
    dnf clean all

RUN pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple langgraph==${VERSION}
