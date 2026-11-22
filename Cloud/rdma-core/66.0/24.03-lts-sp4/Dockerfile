ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
ARG VERSION=66.0

RUN dnf install -y \
      gcc make cmake ninja-build pkgconf \
      libnl3-devel systemd-devel valgrind-devel \
      python3-devel python3-Cython \
    && dnf clean all

WORKDIR /opt

RUN curl -fSL --connect-timeout 30 --retry 3 \
      -o rdma-core-${VERSION}.tar.gz \
      https://github.com/linux-rdma/rdma-core/releases/download/v${VERSION}/rdma-core-${VERSION}.tar.gz \
    && echo "a03fadbb2b523505743ff00f4e0f86d3bfd6e0beacf330357b1dfa8fbd9d246b  rdma-core-${VERSION}.tar.gz" | sha256sum -c - \
    && tar -xzf rdma-core-${VERSION}.tar.gz \
    && rm -f rdma-core-${VERSION}.tar.gz

WORKDIR /opt/rdma-core-${VERSION}

RUN cmake -S . -B build -GNinja -DCMAKE_INSTALL_PREFIX=/usr -DNO_MAN_PAGES=1 \
    && ninja -C build \
    && ninja -C build install

USER root

CMD ["ibv_devinfo", "--help"]
