ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.3.1

RUN dnf install -y curl fuse3 && \
    curl -fSL "https://github.com/juicedata/juicefs/releases/download/v${VERSION}/juicefs-${VERSION}-linux-${TARGETARCH}.tar.gz" \
        -o juicefs.tar.gz && \
    tar -xzf juicefs.tar.gz juicefs && \
    mv juicefs /usr/local/bin/juicefs && \
    rm -f juicefs.tar.gz && \
    dnf clean all

CMD ["juicefs", "--version"]
