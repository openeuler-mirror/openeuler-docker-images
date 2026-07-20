FROM openeuler/openeuler:24.03-lts-sp3

ARG TARGETPLATFORM
ARG SDK_VERSION=3.7.0.38
ENV SDK_VERSION=${SDK_VERSION}

RUN dnf update -y && \
    dnf install -y util-linux xz make gcc gcc-c++ && \
    dnf clean all

COPY EUR.repo /etc/yum.repos.d/maca-sdk.repo

RUN ARCH=$(case "${TARGETPLATFORM}" in \
        "linux/amd64") echo "x86_64" ;; \
        "linux/arm64") echo "aarch64" ;; \
        *) echo "Unsupported TARGETPLATFORM: ${TARGETPLATFORM}" >&2; exit 1 ;; \
    esac) && \
    dnf makecache --refresh && \
    dnf install -y --allowerasing maca-sdk-${ARCH} && \
    dnf clean all

ENTRYPOINT ["/bin/bash"]
