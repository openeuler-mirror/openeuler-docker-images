FROM openeuler/openeuler:24.03-lts-sp4

ARG TARGETPLATFORM
ARG VERSION=1.2.0
ARG CUDA_VERSION=12.8.1
ARG CUDA_BUILD=570.124.06
ARG ARCHITECTURE=70
ARG MAKE_JOBS=8

ENV CUDA_HOME=/usr/local/cuda-12.8
ENV PATH="${CUDA_HOME}/bin:$PATH"

RUN dnf install -y \
        wget git git-lfs make cmake gcc-c++ openmpi-devel bzip2 && \
    git lfs install && \
    dnf clean all

RUN cd /tmp && \
    if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then \
        CUDA_INSTALLER="cuda_${CUDA_VERSION}_${CUDA_BUILD}_linux_sbsa.run"; \
    else \
        CUDA_INSTALLER="cuda_${CUDA_VERSION}_${CUDA_BUILD}_linux.run"; \
    fi && \
    wget -q "https://developer.download.nvidia.com/compute/cuda/${CUDA_VERSION}/local_installers/${CUDA_INSTALLER}" && \
    sh "${CUDA_INSTALLER}" --silent --toolkit && \
    rm -f "${CUDA_INSTALLER}" && \
    ln -sfn "${CUDA_HOME}" /usr/local/cuda

WORKDIR /workspace
RUN git clone https://github.com/LatticeQCD/SIMULATeQCD.git -b v${VERSION} && \
    cd SIMULATeQCD && \
    sed -i 's|LatticeData() {}|LatticeData() = default;|'                    src/base/indexer/bulkIndexer.h && \
    sed -i 's|__device__ __host__ HaloData() {}|__device__ __host__ HaloData() = default;|' src/base/indexer/haloIndexer.h && \
    sed -i 's|#include "nvToolsExt.h"|#include "nvtx3/nvToolsExt.h"|'        src/base/wrapper/gpu_wrapper.h

RUN mkdir -p /workspace/buildSIMULATeQCD && \
    cd /workspace/buildSIMULATeQCD && \
    CUDACXX="${CUDA_HOME}/bin/nvcc" cmake ../SIMULATeQCD \
        -DARCHITECTURE="${ARCHITECTURE}" \
        -DCMAKE_CUDA_ARCHITECTURES="${ARCHITECTURE}" \
        -DCMAKE_CUDA_FLAGS="-D__builtin_ia32_prefetch=__builtin_prefetch" \
        -DUSE_GPU_AWARE_MPI=ON \
        -DUSE_GPU_P2P=ON

RUN cd /workspace/buildSIMULATeQCD && \
    make -j "${MAKE_JOBS}" rhmc

WORKDIR /workspace/buildSIMULATeQCD