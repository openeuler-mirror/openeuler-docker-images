ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG KITEX_VERSION=0.16.2
ARG HERTZ_VERSION=0.10.5

WORKDIR /app

RUN dnf install -y curl && \
    curl -fSL -o go.tar.gz https://golang.google.cn/dl/go1.21.13.linux-${TARGETARCH}.tar.gz && \
    tar -xf go.tar.gz -C /usr/local && \
    rm -f go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
ENV CGO_ENABLED=0
ENV GO111MODULE=on

RUN curl -fSL https://github.com/cloudwego/kitex/archive/refs/tags/v${KITEX_VERSION}.tar.gz \
        -o kitex.tar.gz && \
    tar -xzf kitex.tar.gz && \
    cd kitex-${KITEX_VERSION} && \
    GOARCH=${TARGETARCH} go build -ldflags="-s -w" \
        -o /usr/local/bin/kitex ./tool/cmd/kitex/ && \
    cd /app && \
    rm -rf kitex-* kitex.tar.gz

RUN curl -fSL https://github.com/cloudwego/hertz/archive/refs/tags/v${HERTZ_VERSION}.tar.gz \
        -o hertz.tar.gz && \
    tar -xzf hertz.tar.gz && \
    cd hertz-${HERTZ_VERSION}/cmd/hz && \
    GOARCH=${TARGETARCH} go build -ldflags="-s -w" -o /usr/local/bin/hz . && \
    cd /app && \
    rm -rf hertz-* hertz.tar.gz && \
    dnf clean all

CMD ["kitex", "--version"]
