ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=2.2.3

RUN dnf install -y \
      gcc gcc-gfortran make cmake \
      openmpi-devel openblas-devel lapack-devel && \
    dnf clean all

RUN curl -fSL -o scalapack.tar.gz https://github.com/Reference-ScaLAPACK/scalapack/archive/refs/tags/v${VERSION}.tar.gz && \
    tar -zxf scalapack.tar.gz && \
    cd scalapack-${VERSION} && \
    mkdir build && cd build && \
    cmake .. \
      -DCMAKE_INSTALL_PREFIX=/usr/local/scalapack \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_SHARED_LIBS=ON \
      -DUSE_OPTIMIZED_LAPACK_BLAS=ON && \
    make -j$(nproc) && \
    make install && \
    cd / && rm -rf scalapack-${VERSION} scalapack.tar.gz

ENV LD_LIBRARY_PATH=/usr/local/scalapack/lib64:$LD_LIBRARY_PATH
