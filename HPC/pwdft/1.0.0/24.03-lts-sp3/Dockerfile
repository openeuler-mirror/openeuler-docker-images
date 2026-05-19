ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=1.0.0

RUN yum update -y && \
    yum install -y gcc g++ gfortran cmake git openmpi-devel blas-devel lapack-devel && \
    yum clean all

WORKDIR /opt

RUN ARCH=$(uname -m) && \
    git clone https://github.com/ebylaska/PWDFT.git pwdft && \
    cd pwdft && \
    if [ "$ARCH" = "aarch64" ]; then \
        sed -i 's/-m64//g' Nwpw/CMakeLists.txt && \
        sed -i 's/-mfpmath=sse//g' Nwpw/CMakeLists.txt; \
    fi && \
    mkdir build && cd build && \
    cmake -DNWPW_OPENMP=ON ../Nwpw && \
    make -j$(nproc) && \
    make install

ENV PATH="/usr/local/bin:${PATH}"

WORKDIR /opt/pwdft

LABEL org.opencontainers.image.title="pwdft" \
    org.opencontainers.image.version="${VERSION}"