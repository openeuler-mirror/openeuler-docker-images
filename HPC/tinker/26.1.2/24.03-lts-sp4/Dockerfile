ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE AS builder

ARG VERSION=26.1.2

RUN dnf install -y \
      gcc-gfortran \
      cmake make \
      fftw-devel \
      curl ca-certificates && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 --retry-delay 5 \
      -o /tmp/tinker-${VERSION}.tar.gz \
      https://github.com/TinkerTools/tinker/archive/refs/tags/v${VERSION}.tar.gz && \
    mkdir -p /build/tinker && \
    tar -xzf /tmp/tinker-${VERSION}.tar.gz -C /build/tinker --strip-components=1 && \
    rm -f /tmp/tinker-${VERSION}.tar.gz

RUN mkdir -p /build/tinker/build && \
    cd /build/tinker/build && \
    cmake ../cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DFFTW_THREAD_TYPE=omp && \
    make -j$(nproc) && \
    make install

FROM $BASE

RUN dnf install -y \
      libgfortran libgomp \
      fftw-libs-double && \
    dnf clean all

COPY --from=builder /usr/local/bin/ /usr/local/bin/
COPY --from=builder /build/tinker/params/ /opt/tinker/params/
COPY --from=builder /build/tinker/example/ /opt/tinker/example/

WORKDIR /workspace

USER root

CMD ["/bin/bash"]
