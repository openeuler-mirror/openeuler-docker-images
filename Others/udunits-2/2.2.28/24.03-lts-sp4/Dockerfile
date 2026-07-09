ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=2.2.28

RUN dnf install -y \
        gcc gcc-c++ make cmake \
        flex bison texinfo \
        expat-devel && \
    dnf clean all

RUN curl -fSL -o udunits.tar.gz https://github.com/Unidata/UDUNITS-2/archive/refs/tags/v${VERSION}.tar.gz && \
    tar -xzf udunits.tar.gz && \
    cd UDUNITS-2-${VERSION} && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    make -j$(nproc) && \
    make install && \
    cd / && rm -rf UDUNITS-2-${VERSION} udunits.tar.gz
