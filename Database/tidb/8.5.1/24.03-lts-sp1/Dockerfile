ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE AS builder

ARG VERSION=8.5.1
ARG TARGETARCH
RUN yum install -y make gcc git && \
    curl -fSL -o go.tar.gz https://golang.google.cn/dl/go1.23.7.linux-${TARGETARCH}.tar.gz && \
    tar -xvf go.tar.gz -C /usr/local
ENV PATH="/usr/local/go/bin:${PATH}"
RUN git clone -b v${VERSION} https://github.com/pingcap/tidb.git && \
    cd tidb && \
    make server

# use distroless image as base
FROM openeuler/distroless-base:2.38-oe2403lts
COPY --from=builder /tidb/bin/tidb-server /tidb-server
WORKDIR /
EXPOSE 4000
ENTRYPOINT [ "/tidb-server" ]