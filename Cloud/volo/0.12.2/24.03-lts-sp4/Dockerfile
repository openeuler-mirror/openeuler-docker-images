ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=0.12.2

RUN dnf install -y \
      gcc gcc-c++ make cmake pkgconf perl \
      rust cargo \
      openssl-devel zlib-devel \
      ca-certificates curl && \
    dnf clean all

WORKDIR /build

RUN curl -fSL --connect-timeout 30 --retry 3 \
        -o volo.tar.gz https://github.com/cloudwego/volo/archive/refs/tags/volo-thrift-${VERSION}.tar.gz && \
    mkdir -p volo && \
    tar -xzf volo.tar.gz -C volo --strip-components=1 && \
    cd volo && \
    cargo build --release --locked -p volo-cli && \
    install -Dm755 target/release/volo /usr/local/bin/volo && \
    cd /build && \
    rm -rf volo volo.tar.gz

FROM ${BASE}

RUN dnf install -y \
      rust cargo rustfmt \
      gcc gcc-c++ make \
      ca-certificates && \
    dnf clean all

ENV VOLO_DISABLE_UPDATE_CHECK=1

COPY --from=builder /usr/local/bin/volo /usr/local/bin/volo

WORKDIR /workspace

USER root

CMD ["volo", "--version"]
