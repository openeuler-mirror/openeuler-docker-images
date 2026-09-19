ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=0.14.5
ARG TARGETARCH
ARG GOLANG_VERSION=1.21.13
ARG GO_SHA256_AMD64=502fc16d5910562461e6a6631fb6377de2322aad7304bf2bcd23500ba9dab4a7
ARG GO_SHA256_ARM64=2ca2d70dc9c84feef959eb31f2a5aac33eefd8c97fe48f1548886d737bffabd4

RUN case "${TARGETARCH}" in \
        amd64) go_sha256="${GO_SHA256_AMD64}" ;; \
        arm64) go_sha256="${GO_SHA256_ARM64}" ;; \
        *) echo "unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac && \
    curl -fSL --connect-timeout 30 --retry 3 -o go.tar.gz https://golang.google.cn/dl/go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz && \
    echo "${go_sha256}  go.tar.gz" | sha256sum -c - && \
    tar -xzf go.tar.gz -C /usr/local && \
    rm -f go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
ENV CGO_ENABLED=0
ENV GO111MODULE=on

WORKDIR /app

RUN curl -fSL --connect-timeout 30 --retry 3 -o kitex.tar.gz https://github.com/cloudwego/kitex/archive/refs/tags/v${VERSION}.tar.gz && \
    tar -xzf kitex.tar.gz && \
    cd kitex-${VERSION} && \
    GOARCH=${TARGETARCH} go build -ldflags="-s -w" -o /usr/local/bin/kitex ./tool/cmd/kitex/ && \
    cd /app && \
    rm -rf kitex-${VERSION} kitex.tar.gz

FROM ${BASE}

COPY --from=builder /usr/local/go /usr/local/go
COPY --from=builder /usr/local/bin/kitex /usr/local/bin/kitex

ENV PATH="/usr/local/go/bin:/usr/local/bin:${PATH}"
ENV CGO_ENABLED=0

WORKDIR /workspace

USER root

CMD ["kitex", "--version"]
