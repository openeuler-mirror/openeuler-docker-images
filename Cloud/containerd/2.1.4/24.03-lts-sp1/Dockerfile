ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=2.1.4

RUN dnf update -y \
    && dnf install -y wget \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /usr/local/containerd

RUN wget https://github.com/containerd/containerd/releases/download/v${VERSION}/containerd-${VERSION}-linux-${TARGETARCH}.tar.gz \
    && tar -zxvf containerd-${VERSION}-linux-${TARGETARCH}.tar.gz \
    && rm -f containerd-${VERSION}-linux-${TARGETARCH}.tar.gz

WORKDIR /usr/local/containerd/bin

CMD ["./containerd", "--help"]