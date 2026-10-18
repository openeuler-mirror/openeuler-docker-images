ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=2.14.1
ARG TORCHVISION_VERSION=0.29.1

RUN dnf install -y python3-pip && \
    dnf clean all

RUN pip install --no-cache-dir \
        --index-url https://download.pytorch.org/whl/cpu \
        torch==${VERSION} \
        torchvision==${TORCHVISION_VERSION}
