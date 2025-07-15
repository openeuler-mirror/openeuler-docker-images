ARG BASE=openeuler/openeuler:24.03-lts
ARG VERSION=24.4.0

FROM $BASE

ARG VERSION
ARG TARGETARCH

RUN yum update -y && \
    yum install -y wget && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    rm -rf /tmp/*

WORKDIR /root

RUN case "${TARGETARCH}" in \
        amd64) NODE_ARCH=x64 ;; \
        arm64) NODE_ARCH=arm64 ;; \
    esac && \
    wget https://nodejs.org/download/release/v$VERSION/node-v$VERSION-linux-$NODE_ARCH.tar.gz && \
    tar -xzf node-v$VERSION-linux-$NODE_ARCH.tar.gz && \
    mv node-v$VERSION-linux-$NODE_ARCH /usr/local/node && \
    ln -s /usr/local/node/bin/node /usr/local/bin/node && \
    ln -s /usr/local/node/bin/npm /usr/local/bin/npm && \
    ln -s /usr/local/node/bin/npx /usr/local/bin/npx && \
    rm -fr node-v$VERSION-linux-$NODE_ARCH.tar.gz

