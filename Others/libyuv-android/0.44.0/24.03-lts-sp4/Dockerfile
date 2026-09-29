ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=0.44.0

RUN dnf install -y \
      cmake gcc-c++ make \
      curl tar && \
    dnf clean all

WORKDIR /opt

RUN curl -fSL --connect-timeout 30 --retry 5 --retry-delay 5 \
      -o libyuv-android-${VERSION}.tar.gz \
      https://github.com/crow-misia/libyuv-android/archive/refs/tags/v${VERSION}.tar.gz && \
    tar -zxf libyuv-android-${VERSION}.tar.gz && \
    cmake -S libyuv-android-${VERSION}/core/deps/libyuv \
          -B libyuv-build \
          -DCMAKE_INSTALL_PREFIX=/usr/local \
          -DCMAKE_BUILD_TYPE=Release && \
    cmake --build libyuv-build -j$(nproc) && \
    cmake --install libyuv-build

FROM ${BASE}

ARG VERSION=0.44.0

RUN dnf install -y \
      cmake gcc-c++ make && \
    dnf clean all

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/include /usr/local/include
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /opt/libyuv-android-${VERSION}/core/deps/libyuv/LICENSE /usr/local/share/licenses/libyuv/LICENSE
COPY --from=builder /opt/libyuv-android-${VERSION}/core/deps/libyuv/PATENTS /usr/local/share/licenses/libyuv/PATENTS

RUN ldconfig

ENV LD_LIBRARY_PATH=/usr/local/lib

USER root

CMD ["bash"]
