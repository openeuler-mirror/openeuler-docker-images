ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
ARG VERSION=3.4.0

RUN dnf update -y \
    && dnf install -y python3-pip \
    && dnf clean all \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/dnf

RUN pip3 install paddlepaddle==${VERSION} -i https://www.paddlepaddle.org.cn/packages/stable/cpu/
