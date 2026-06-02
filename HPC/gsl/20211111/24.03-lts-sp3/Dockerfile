ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=20211111

RUN dnf install -y \
      git cmake make \
      gcc gcc-c++ gcc-gfortran && \
    dnf clean all

RUN git clone --branch ${VERSION} --depth 1 https://github.com/ampl/gsl.git /tmp/gsl-src && \
    mkdir /tmp/gsl-src/build && cd /tmp/gsl-src/build && \
    cmake .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DNO_AMPL_BINDINGS=1 \
      -DGSL_DISABLE_TESTS=1 && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf /tmp/gsl-src

