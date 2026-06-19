ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TORCH_VERSION=2.12.1
ARG VERSION=0.27.1

RUN dnf install -y libpng libjpeg-turbo python3-pip && \
    dnf clean all

RUN pip install --no-cache-dir \
        --index-url https://download.pytorch.org/whl/cpu \
        torch==${TORCH_VERSION} \
        torchvision==${VERSION}
