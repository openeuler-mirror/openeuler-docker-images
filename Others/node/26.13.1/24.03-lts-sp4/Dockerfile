ARG BASE=openeuler/openeuler:24.03-lts-sp4
ARG VERSION=26.13.1

FROM $BASE
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION
ARG TARGETARCH

RUN yum install -y wget libatomic && \
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
