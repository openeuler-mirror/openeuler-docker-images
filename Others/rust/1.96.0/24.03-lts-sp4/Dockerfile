ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=1.96.0

RUN dnf install -y \
        gcc gcc-c++ \
        make cmake \
        ca-certificates curl && \
    dnf clean all

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain ${VERSION}

CMD ["bash"]
