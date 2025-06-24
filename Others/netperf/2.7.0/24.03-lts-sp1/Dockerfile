ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=2.7.0

RUN dnf update -y \
    && dnf install -y wget make gcc autoconf automake libtool texinfo patch \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

COPY netperf-fix-multiple-definition.patch /opt/netperf-fix-multiple-definition.patch
COPY netserver-suppress-debug-log-by-default.patch /opt/netserver-suppress-debug-log-by-default.patch

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64-pc-linux-gnu"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64-unknown-linux-gnu"; \
    fi; \
    wget https://github.com/HewlettPackard/netperf/archive/refs/tags/netperf-${VERSION}.tar.gz \
    && tar -zxvf netperf-${VERSION}.tar.gz \
    && rm -f netperf-${VERSION}.tar.gz \
    && cd netperf-netperf-${VERSION} \
    && patch -p1 < /opt/netperf-fix-multiple-definition.patch \
    && patch -p1 < /opt/netserver-suppress-debug-log-by-default.patch \
    && ./configure --build=${BUILDARCH} \
    && make -j $(nproc) \
    && make install

CMD ["netperf", "--help"]