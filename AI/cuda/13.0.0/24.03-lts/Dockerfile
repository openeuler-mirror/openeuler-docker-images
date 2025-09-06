ARG BASE=openeuler/openeuler:24.03-lts
ARG VERSION=13.0.0
ARG DRIVER_VERSION=580.65.06

FROM $BASE
ARG TARGETPLATFORM

ARG DRIVER_VERSION
ARG VERSION

RUN yum update -y && \
    yum install -y wget gcc g++ && \
    yum clean all

RUN \
    if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then \
        CUDA_TOOLKIT_URL="https://developer.download.nvidia.com/compute/cuda/${VERSION}/local_installers/cuda_${VERSION}_${DRIVER_VERSION}_linux_sbsa.run"; \
    elif [ "${TARGETPLATFORM}" = "linux/amd64" ]; then \
        CUDA_TOOLKIT_URL="https://developer.download.nvidia.com/compute/cuda/${VERSION}/local_installers/cuda_${VERSION}_${DRIVER_VERSION}_linux.run"; \
    fi && \
    wget $CUDA_TOOLKIT_URL -O /tmp/cuda-toolkit.run && \
    bash /tmp/cuda-toolkit.run --silent --toolkit && \
    rm -f /tmp/cuda-toolkit.run

ENV PATH=/usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH