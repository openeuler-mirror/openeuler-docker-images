ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG TARGETPLATFORM
ARG VERSION=1.2.0
ARG CUDA_VERSION=12.4.0
ARG DRIVER_VERSION=550.54.14

RUN dnf update -y \
    && dnf install -y gcc gcc-c++ cmake make wget openmpi-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# Install CUDA toolkit
RUN \
    if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then \
        CUDA_TOOLKIT_URL="https://developer.download.nvidia.com/compute/cuda/${CUDA_VERSION}/local_installers/cuda_${CUDA_VERSION}_${DRIVER_VERSION}_linux_sbsa.run"; \
    elif [ "${TARGETPLATFORM}" = "linux/amd64" ]; then \
        CUDA_TOOLKIT_URL="https://developer.download.nvidia.com/compute/cuda/${CUDA_VERSION}/local_installers/cuda_${CUDA_VERSION}_${DRIVER_VERSION}_linux.run"; \
    fi && \
    wget ${CUDA_TOOLKIT_URL} -O /tmp/cuda-toolkit.run && \
    bash /tmp/cuda-toolkit.run --silent --toolkit && \
    rm -f /tmp/cuda-toolkit.run

ENV PATH=/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

# Patch glibc math-vector.h for CUDA compatibility on ARM64
# The ARM SIMD vector types (__Float32x4_t, __SVFloat32_t, etc.) are not
# understood by CUDA's cudafe++ frontend. Disable the vector math declarations.
RUN if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then \
        sed -i 's/#if __GNUC_PREREQ(9, 0)/#if 0/' /usr/include/bits/math-vector.h && \
        sed -i 's/#if __GNUC_PREREQ(10, 0) || __glibc_clang_prereq(11, 0)/#if 0/' /usr/include/bits/math-vector.h; \
    fi

WORKDIR /opt

RUN wget https://github.com/LatticeQCD/SIMULATeQCD/archive/refs/tags/v${VERSION}.tar.gz \
    && tar -xzf v${VERSION}.tar.gz \
    && rm -f v${VERSION}.tar.gz

WORKDIR /opt/SIMULATeQCD-${VERSION}

# Patch non-trivial default constructors to allow __constant__ variables.
# CUDA 12.x requires trivial constructors for __constant__ memory.
# Change empty constructor bodies {} to = default for LatticeData and HaloData.
RUN sed -i 's/    LatticeData() {}/    LatticeData() = default;/' src/base/indexer/bulkIndexer.h \
    && sed -i 's/    __device__ __host__ HaloData() {}/    __device__ __host__ HaloData() = default;/' src/base/indexer/haloIndexer.h

RUN mkdir -p build && cd build \
    && cmake .. \
        -DCMAKE_INSTALL_PREFIX=/opt/rhmc-install \
        -DUSE_CUDA=ON \
        -DARCHITECTURE=70 \
    && make -j$(nproc) \
    && make install

FROM ${BASE}

RUN dnf install -y openmpi \
    && dnf clean all \
    && rm -rf /var/cache/dnf

COPY --from=builder /opt/rhmc-install /opt/rhmc-install
COPY --from=builder /usr/local/cuda /usr/local/cuda

ENV PATH=/opt/rhmc-install/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH=/opt/rhmc-install/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

WORKDIR /opt/rhmc-install

CMD ["bash"]