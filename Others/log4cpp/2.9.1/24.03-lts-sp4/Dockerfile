ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=2.9.1

RUN dnf install -y \
      cmake gcc-c++ make \
      && dnf clean all \
      && rm -rf /var/cache/dnf

WORKDIR /opt

RUN curl -fSL --connect-timeout 30 --retry 3 -o log4cpp-${VERSION}.tar.gz https://github.com/orocos-toolchain/log4cpp/archive/refs/tags/v${VERSION}.tar.gz && \
    tar -zxf log4cpp-${VERSION}.tar.gz && \
    rm -f log4cpp-${VERSION}.tar.gz && \
    cmake -S log4cpp-${VERSION} -B log4cpp-${VERSION}/build \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_TESTING=OFF \
      -DCMAKE_CXX_STANDARD=14 \
      -DCMAKE_CXX_FLAGS="-include time.h" \
      -DCMAKE_INSTALL_PREFIX=/usr && \
    cmake --build log4cpp-${VERSION}/build -j$(nproc) && \
    DESTDIR=/opt/stage cmake --install log4cpp-${VERSION}/build

FROM ${BASE}

ARG VERSION=2.9.1

RUN dnf install -y \
      gcc-c++ make \
      && dnf clean all \
      && rm -rf /var/cache/dnf

COPY --from=builder /opt/stage/usr /usr
COPY --from=builder /opt/log4cpp-${VERSION}/COPYING /usr/share/licenses/log4cpp/COPYING

RUN ldconfig

USER root

CMD ["bash"]
