ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=4.2

RUN dnf install -y gcc gcc-c++ make cmake curl tar gzip git && \
    if [ "$(uname -m)" = "x86_64" ]; then dnf install -y nasm; fi && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 -o /tmp/x265.tar.gz \
      https://github.com/Multicorewareinc/x265/releases/download/${VERSION}/x265_${VERSION}.tar.gz && \
    mkdir -p /x265 && \
    tar -xzf /tmp/x265.tar.gz -C /x265 --strip-components=1 && \
    rm -f /tmp/x265.tar.gz

RUN cmake -S /x265/source -B /x265/build-release \
      -DCMAKE_BUILD_TYPE=Release \
      -DENABLE_PIC=ON \
      -DENABLE_ASSEMBLY=ON \
      -DCMAKE_VERBOSE_MAKEFILE=ON \
      -DCMAKE_C_FLAGS=-O3 \
      -DCMAKE_CXX_FLAGS=-O3 \
      -DHIGH_BIT_DEPTH=OFF \
      -DENABLE_TESTS=ON \
      -DENABLE_SHARED=ON \
      -DENABLE_LIBNUMA=OFF \
      -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --build /x265/build-release -j$(nproc) && \
    cmake --install /x265/build-release

RUN echo /usr/local/lib > /etc/ld.so.conf.d/x265.conf && ldconfig && \
    x265 --version 2>&1 | grep -F "HEVC encoder version ${VERSION}"

WORKDIR /workspace

CMD ["x265", "--help"]
