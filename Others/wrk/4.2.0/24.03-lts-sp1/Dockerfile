ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} AS builder

ARG VERSION=4.2.0

RUN dnf update -y \
    && dnf install -y git gcc make curl unzip openssl-devel pkgconf \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN git clone -b ${VERSION} --depth 1 https://github.com/wg/wrk.git

WORKDIR /opt/wrk

RUN make obj/LuaJIT-2.1 \
    && make -j \
    && cp ./wrk /usr/local/bin/

CMD ["wrk", "--version"]
