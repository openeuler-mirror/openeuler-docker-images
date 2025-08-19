ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE AS builder

ARG VERSION=3.6.4
ARG TARGETARCH
RUN yum install -y make gcc git && \
    curl -fSL -o go.tar.gz https://golang.google.cn/dl/go1.23.9.linux-${TARGETARCH}.tar.gz && \
    tar -xvf go.tar.gz -C /usr/local
ENV PATH="/usr/local/go/bin:${PATH}"
RUN curl -fSL -o etcd.tar.gz https://github.com/etcd-io/etcd/archive/refs/tags/v${VERSION}.tar.gz && \
    mkdir -p /etcd && \
    tar -zxf etcd.tar.gz -C /etcd --strip-components=1 && \
    rm -rf etcd.tar.gz && \
    cd /etcd && \
    make -j$nproc

# use distroless image as base
FROM openeuler/distroless-static:1.0.0-oe2403lts

COPY --from=builder /etcd/bin/etcd /usr/bin/etcd
COPY --from=builder /etcd/bin/etcdctl /usr/bin/etcdctl
COPY --from=builder /etcd/bin/etcdutl /usr/bin/etcdutl

EXPOSE 2379 2380
CMD [ "etcd" ]