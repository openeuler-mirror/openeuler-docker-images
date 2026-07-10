ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=v4.2.0

RUN dnf update -y \
    && dnf install -y gcc gcc-c++ gcc-gfortran openmpi-devel cmake \
    boost-devel libxml2-devel hdf5-devel fftw-devel \
    blas-devel lapack-devel wget \
    && dnf clean all \
    && rm -rf /var/cache/dnf

ENV PATH=/usr/lib64/openmpi/bin:$PATH

WORKDIR /opt

RUN wget https://github.com/QMCPACK/qmcpack/archive/refs/tags/${VERSION}.tar.gz \
    && tar -xzf ${VERSION}.tar.gz \
    && rm -f ${VERSION}.tar.gz

WORKDIR /opt/qmcpack-4.2.0/build

RUN cmake -DCMAKE_C_COMPILER=mpicc -DCMAKE_CXX_COMPILER=mpicxx \
    -DCMAKE_BUILD_TYPE=Release .. \
    && make -j$(nproc)

FROM ${BASE}

RUN dnf install -y openmpi hdf5 fftw libxml2 boost blas lapack \
    && dnf clean all \
    && rm -rf /var/cache/dnf

ENV PATH=/usr/lib64/openmpi/bin:$PATH

COPY --from=builder /opt/qmcpack-4.2.0/build/bin /opt/qmcpack/bin
COPY --from=builder /opt/qmcpack-4.2.0/tests /opt/qmcpack/tests

WORKDIR /opt/qmcpack

CMD ["bin/qmcpack", "--help"]