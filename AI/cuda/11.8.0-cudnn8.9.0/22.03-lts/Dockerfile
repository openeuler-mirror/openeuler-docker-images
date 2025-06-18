ARG BASE=openeuler/openeuler:22.03

FROM ${BASE} AS cuda-installer

ARG TARGETPLATFORM

ENV PATH=${PATH}:/usr/local/cuda-11.8/bin
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda-11.8/lib64

RUN yum update -y && \
    yum install -y \
        wget \
        gcc \
        make \
        xz-devel \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN \
    if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then \
        CUDA_URL="https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux_sbsa.run"; \
    else \
        CUDA_URL="https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run"; \
    fi && \
    wget --quiet ${CUDA_URL} -O ~/cuda_11.8.0_520.61.05_linux.run && \
    chmod +x ~/cuda_11.8.0_520.61.05_linux.run && \
    ~/cuda_11.8.0_520.61.05_linux.run --toolkit --silent && \
    rm -f ~/cuda_11.8.0_520.61.05_linux.run

RUN if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then \
        CUDNN_URL="https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-sbsa/cudnn-linux-sbsa-8.9.0.131_cuda11-archive.tar.xz"; \
    else \
        CUDNN_URL="https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-8.9.0.131_cuda11-archive.tar.xz"; \
    fi && \
    mkdir -p /tmp/cudnn && \
    wget --quiet ${CUDNN_URL} -O /tmp/cudnn.tar.xz && \
    tar -xvf /tmp/cudnn.tar.xz -C /tmp/cudnn --strip-components=1 && \
    cp /tmp/cudnn/include/cudnn.h /usr/local/cuda-11.8/include && \
    cp /tmp/cudnn/lib/libcudnn* /usr/local/cuda-11.8/lib64 && \
    chmod a+r /usr/local/cuda-11.8/include/cudnn.h /usr/local/cuda-11.8/lib64/libcudnn* && \
    rm -rf /tmp/cudnn*
