ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=5.0.3

RUN dnf install -y \
      git make \
      gcc-gfortran \
      openmpi-devel \
      openblas-devel lapack-devel && \
    dnf clean all

ENV PATH=/usr/lib64/openmpi/bin:$PATH

RUN git clone --depth 1 --branch ${VERSION} https://github.com/ParaFEM/ParaFEM.git /tmp/parafem-src && \
    cd /tmp/parafem-src/parafem && \
    sed -i 's|^FC=/usr/bin/mpif90|FC=mpif90|' build/linuxdesktop.inc && \
    ./make-parafem MACHINE=linuxdesktop && \
    mkdir -p /usr/local/parafem && \
    cp -r bin include lib /usr/local/parafem/ && \
    rm -rf /tmp/parafem-src

ENV PATH=/usr/local/parafem/bin:$PATH
