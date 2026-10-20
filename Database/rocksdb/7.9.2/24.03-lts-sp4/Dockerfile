ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=7.9.2

RUN dnf install -y \
      gcc gcc-c++ make cmake git \
      gflags gflags-devel \
      snappy snappy-devel \
      zstd-devel zlib-devel \
      libatomic \
      && dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 -o /tmp/rocksdb.tar.gz \
      https://github.com/facebook/rocksdb/archive/refs/tags/v${VERSION}.tar.gz && \
    mkdir -p /rocksdb && \
    tar -zxf /tmp/rocksdb.tar.gz -C /rocksdb --strip-components=1 && \
    rm -f /tmp/rocksdb.tar.gz

RUN cmake -S /rocksdb -B /rocksdb/build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DFAIL_ON_WARNINGS=OFF \
      -DWITH_SNAPPY=ON \
      -DWITH_ZSTD=ON \
      -DWITH_ZLIB=ON && \
    cmake --build /rocksdb/build -j$(nproc) && \
    cmake --install /rocksdb/build && \
    install -Dm755 "$(find /rocksdb/build -name db_bench -type f -executable | head -1)" /usr/local/bin/db_bench

FROM ${BASE}

RUN dnf install -y snappy zstd zlib gflags libstdc++ libgcc && \
    dnf clean all

COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/include /usr/local/include
COPY --from=builder /usr/local/bin/db_bench /usr/local/bin/db_bench

ENV LD_LIBRARY_PATH=/usr/local/lib

WORKDIR /workspace

CMD ["bash"]
