ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS build

ARG VERSION=7.8.0

RUN dnf install -y \
      gcc make cmake \
      curl tar && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 \
      -o sundials-${VERSION}.tar.gz \
      https://github.com/llnl/sundials/releases/download/v${VERSION}/sundials-${VERSION}.tar.gz && \
    tar -zxf sundials-${VERSION}.tar.gz && \
    cd sundials-${VERSION} && \
    mkdir build && cd build && \
    cmake .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local/sundials \
      -DCMAKE_INSTALL_LIBDIR=lib64 && \
    make -j$(nproc) && \
    make install && \
    for d in /usr/local/sundials/examples/*/*; do \
      if [ -f "${d}/Makefile" ]; then \
        make -C "${d}" >/dev/null || true; \
      fi; \
    done && \
    cd / && \
    rm -rf sundials-${VERSION} sundials-${VERSION}.tar.gz

FROM ${BASE}

COPY --from=build /usr/local/sundials /usr/local/sundials

ENV LD_LIBRARY_PATH=/usr/local/sundials/lib64:${LD_LIBRARY_PATH}

USER root
