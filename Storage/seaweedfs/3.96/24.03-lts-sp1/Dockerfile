ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} AS builder

ARG TARGETARCH
ARG VERSION=3.96
ARG GO_VERSION=1.23.3

WORKDIR /app
RUN curl -fSL -o go.tar.gz https://golang.google.cn/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    tar -xvf go.tar.gz -C /usr/local  

ENV PATH="/usr/local/go/bin:${PATH}"
ENV GO111MODULE=on
ENV GOPROXY=https://repo.huaweicloud.com/repository/goproxy/
ENV GONOSUMDB=*
RUN curl -fSL -o seaweedfs.tar.gz https://github.com/seaweedfs/seaweedfs/archive/refs/tags/${VERSION}.tar.gz && \
    mkdir -p /app/seaweedfs && \
    tar -zxf seaweedfs.tar.gz -C /app/seaweedfs --strip-components=1

WORKDIR /app/seaweedfs/weed
RUN go build

FROM ${BASE}

COPY --from=builder /app/seaweedfs/weed/weed /usr/bin/weed
ENTRYPOINT ["/usr/bin/weed"]