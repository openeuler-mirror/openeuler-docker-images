ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
# VERSION is read by the image version detector and selects the Kitex source tag.
ARG VERSION=0.16.4
ARG HERTZ_VERSION=0.10.6
ARG VOLO_VERSION=0.12.2
ARG EINO_VERSION=0.9.22
ARG GO_VERSION=1.24.4

RUN dnf install -y \
        curl git gzip tar ca-certificates \
        gcc gcc-c++ make cmake pkgconf perl \
        rust cargo rustfmt openssl-devel zlib-devel && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 -o /tmp/go.tar.gz \
        https://golang.google.cn/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    tar -xzf /tmp/go.tar.gz -C /usr/local && \
    rm -f /tmp/go.tar.gz

ENV PATH=/usr/local/go/bin:${PATH}
ENV GOPATH=/go
ENV GOTOOLCHAIN=local
ENV CGO_ENABLED=0
ENV GO111MODULE=on
ENV VOLO_DISABLE_UPDATE_CHECK=1

WORKDIR /build

RUN curl -fSL --connect-timeout 30 --retry 3 -o kitex.tar.gz \
        https://github.com/cloudwego/kitex/archive/refs/tags/v${VERSION}.tar.gz && \
    mkdir kitex && \
    tar -xzf kitex.tar.gz -C kitex --strip-components=1 && \
    cd kitex && \
    go build -ldflags="-s -w" -o /usr/local/bin/kitex ./tool/cmd/kitex && \
    cd /build && \
    rm -rf kitex kitex.tar.gz

RUN curl -fSL --connect-timeout 30 --retry 3 -o hertz.tar.gz \
        https://github.com/cloudwego/hertz/archive/refs/tags/v${HERTZ_VERSION}.tar.gz && \
    mkdir hertz && \
    tar -xzf hertz.tar.gz -C hertz --strip-components=1 && \
    cd hertz/cmd/hz && \
    go build -ldflags="-s -w" -o /usr/local/bin/hz . && \
    cd /build && \
    rm -rf hertz hertz.tar.gz

RUN curl -fSL --connect-timeout 30 --retry 3 -o volo.tar.gz \
        https://github.com/cloudwego/volo/archive/refs/tags/volo-thrift-${VOLO_VERSION}.tar.gz && \
    mkdir volo && \
    tar -xzf volo.tar.gz -C volo --strip-components=1 && \
    cd volo && \
    cargo build --release --locked -p volo-cli && \
    install -Dm755 target/release/volo /usr/local/bin/volo && \
    cd /build && \
    rm -rf volo volo.tar.gz

RUN curl -fSL --connect-timeout 30 --retry 3 -o eino.tar.gz \
        https://github.com/cloudwego/eino/archive/refs/tags/v${EINO_VERSION}.tar.gz && \
    mkdir -p /eino && \
    tar -xzf eino.tar.gz -C /eino --strip-components=1 && \
    rm -f eino.tar.gz && \
    cd /eino && \
    go mod download && \
    go build ./...

WORKDIR /workspace

CMD ["kitex", "--version"]
