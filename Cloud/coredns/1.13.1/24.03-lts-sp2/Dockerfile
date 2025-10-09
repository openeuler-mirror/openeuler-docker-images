ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG VERSION=1.13.1
ARG TARGETARCH

RUN dnf update -y \
    && dnf install -y wget \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /usr/local/coredns

RUN wget https://github.com/coredns/coredns/releases/download/v${VERSION}/coredns_${VERSION}_linux_${TARGETARCH}.tgz \
    && tar -zxvf coredns_${VERSION}_linux_${TARGETARCH}.tgz \
    && rm -f coredns_${VERSION}_linux_${TARGETARCH}.tgz

WORKDIR /usr/local/coredns

CMD ["./coredns", "--help"]