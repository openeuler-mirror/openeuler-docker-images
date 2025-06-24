ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} AS builder
ARG VERSION=25.03

RUN dnf install -y \
    git meson ninja-build gcc make \
    numactl-devel elfutils-libelf-devel \
    python3-pyelftools pkgconfig \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN git clone -b v${VERSION} --depth 1 https://github.com/DPDK/dpdk.git /dpdk && \
    git config --global --add safe.directory /dpdk

WORKDIR /dpdk

RUN meson setup build -Dplatform=generic && \
    cd build && \
    ninja && \
    meson install

ENV PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH \
    LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH

CMD ["bash"]