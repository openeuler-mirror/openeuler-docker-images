ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} AS builder
ARG VERSION=24.09

RUN dnf update -y \
    && dnf install -y git make gcc \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

WORKDIR /opt

RUN git clone -b v${VERSION} --depth 1 https://github.com/spdk/spdk \
    && cd spdk/ \
    && git submodule update --init

WORKDIR /opt/spdk

RUN ./scripts/pkgdep.sh \
    && ./configure \
    && make -j$(nproc)

CMD ["./test/unit/unittest.sh"]
