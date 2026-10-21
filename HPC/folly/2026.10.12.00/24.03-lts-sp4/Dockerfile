ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=2026.10.12.00

RUN dnf install -y \
      git cmake make \
      gcc gcc-c++ \
      boost-devel \
      gflags-devel glog-devel \
      fmt-devel libevent-devel openssl-devel zlib-devel \
      bzip2-devel xz-devel lz4-devel zstd-devel snappy-devel \
      libsodium-devel libunwind-devel \
      elfutils-libelf-devel libdwarf-devel \
      libaio-devel liburing-devel binutils-devel && \
    dnf clean all

RUN git clone --branch v${VERSION} --depth 1 https://github.com/facebook/folly.git /tmp/folly-src && \
    cmake -S /tmp/folly-src -B /tmp/folly-src/_build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DBUILD_TESTS=OFF \
      -DBUILD_BENCHMARKS=OFF && \
    cmake --build /tmp/folly-src/_build -j$(nproc) && \
    cmake --install /tmp/folly-src/_build && \
    ldconfig && \
    rm -rf /tmp/folly-src
