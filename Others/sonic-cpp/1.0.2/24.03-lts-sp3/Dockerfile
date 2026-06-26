ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=1.0.2

RUN dnf install -y git gcc gcc-c++ && dnf clean all && \
    git clone -b v${VERSION} --depth 1 https://github.com/bytedance/sonic-cpp.git && \
    cp -r sonic-cpp/include /usr/local/include/sonic && \
    rm -rf sonic-cpp
