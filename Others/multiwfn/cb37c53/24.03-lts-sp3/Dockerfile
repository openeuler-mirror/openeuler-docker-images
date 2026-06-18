ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE} AS builder

ARG TARGETARCH
ARG VERSION=cb37c53

RUN dnf install -y \
      git gcc gcc-c++ gcc-gfortran make \
      openblas-devel lapack-devel && \
    dnf clean all

WORKDIR /workspace
RUN git clone https://github.com/foxtran/MultiWFN.git && \
    cd MultiWFN && \
    git checkout ${VERSION}

RUN cd /workspace/MultiWFN/src && \
    sed -i \
      -e 's/^FC = ifort/FC = gfortran/' \
      -e 's/^OPT = /OPT = -ffree-line-length-none /' \
      -e 's/-qopenmp-link=static//g' \
      -e 's/-qopenmp/-fopenmp/g' \
      -e 's/-fpp/-cpp/' \
      -e 's/-mkl/-lopenblas -llapack/' \
      -e 's/-diag-disable [0-9,]\+//g' \
      -e 's/-threads//g' \
      -e 's/-static-intel//g' \
      -e 's/-DINTEL_MKL//g' \
      -e 's/msse3/march=native/' \
      -e 's/-qopt-matmul//g' \
      -e 's|\$(SIMD)|-march=native|' \
      Makefile && \
    make noGUI

FROM ${BASE}

ARG TARGETARCH

RUN dnf install -y \
      gcc-gfortran make \
      openblas-devel lapack-devel && \
    dnf clean all

COPY --from=builder /workspace/MultiWFN /workspace/MultiWFN

ENV PATH=/workspace/MultiWFN/src:$PATH
WORKDIR /workspace/MultiWFN/src
