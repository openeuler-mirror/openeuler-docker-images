ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.14.1

WORKDIR /app

RUN dnf install -y curl && \
    curl -fSL -o go.tar.gz https://golang.google.cn/dl/go1.24.4.linux-${TARGETARCH}.tar.gz && \
    tar -xf go.tar.gz -C /usr/local && rm -f go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
ENV CGO_ENABLED=0
ENV GO111MODULE=on

RUN curl -fSL https://github.com/klauspost/reedsolomon/archive/refs/tags/v${VERSION}.tar.gz \
        -o reedsolomon.tar.gz && \
    tar -xzf reedsolomon.tar.gz && \
    cd reedsolomon-${VERSION} && \
    GOARCH=${TARGETARCH} go build -ldflags="-s -w" \
        -o /usr/local/bin/simple-encoder ./examples/simple-encoder.go && \
    GOARCH=${TARGETARCH} go build -ldflags="-s -w" \
        -o /usr/local/bin/simple-decoder ./examples/simple-decoder.go && \
    GOARCH=${TARGETARCH} go build -ldflags="-s -w" \
        -o /usr/local/bin/stream-encoder ./examples/stream-encoder.go && \
    GOARCH=${TARGETARCH} go build -ldflags="-s -w" \
        -o /usr/local/bin/stream-decoder ./examples/stream-decoder.go && \
    cd /app && rm -rf reedsolomon-${VERSION} reedsolomon.tar.gz && \
    dnf -y remove curl && dnf clean all

CMD ["simple-encoder", "--help"]
