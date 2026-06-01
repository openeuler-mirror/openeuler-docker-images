ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG RUST_VERSION=1.95.0

RUN dnf install -y \
        gcc gcc-c++ \
        make cmake \
        ca-certificates curl && \
    dnf clean all

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain ${RUST_VERSION}

CMD ["bash"]
