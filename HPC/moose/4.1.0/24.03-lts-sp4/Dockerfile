ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=4.1.0

RUN dnf install -y \
      git cmake make \
      gcc gcc-c++ && \
    dnf clean all

RUN git clone --branch v${VERSION} --depth 1 https://github.com/taskflow/taskflow.git /tmp/taskflow-src && \
    mkdir /tmp/taskflow-src/build && cd /tmp/taskflow-src/build && \
    cmake .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DTF_BUILD_EXAMPLES=OFF \
      -DTF_BUILD_TESTS=OFF \
      -DTF_BUILD_BENCHMARKS=OFF && \
    cmake --build . -j$(nproc) && \
    cmake --install . && \
    rm -rf /tmp/taskflow-src

FROM ${BASE}

RUN dnf install -y gcc-c++ && dnf clean all

COPY --from=builder /usr/local /usr/local

USER root
