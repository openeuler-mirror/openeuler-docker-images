ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=2026.11.23.00

# liburing-devel is intentionally not installed: openEuler 24.03-LTS-SP4 only
# ships liburing 2.4, but folly 2026.11.23 uses the io_uring zero-copy RX API
# (IORING_REGISTER_ZCRX_CTRL, io_uring_register_ifq, struct io_uring_sqe::
# zcrx_ifq_idx, ZCRX_*, IOU_PBUF_RING_INC, ...) that only exists in much newer
# liburing releases. Without <liburing.h> folly defines FOLLY_HAS_LIBURING 0 and
# compiles the io_uring integration out, instead of failing to build.
RUN dnf install -y \
      git cmake make \
      gcc gcc-c++ \
      boost-devel \
      gflags-devel glog-devel \
      fmt-devel libevent-devel openssl-devel zlib-devel \
      bzip2-devel xz-devel lz4-devel zstd-devel snappy-devel \
      libsodium-devel libunwind-devel \
      elfutils-libelf-devel libdwarf-devel \
      libaio-devel binutils-devel && \
    dnf clean all

# folly's CMake does not derive PACKAGE_VERSION from the git tag; it hardcodes
# a development default ("0.58.0-dev"), which leaks into libfolly.pc. Pin the
# installed pkg-config version to the release tag so it matches the image tag.
RUN git clone --branch v${VERSION} --depth 1 https://github.com/facebook/folly.git /tmp/folly-src && \
    cmake -S /tmp/folly-src -B /tmp/folly-src/_build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DPACKAGE_VERSION=${VERSION} \
      -DBUILD_TESTS=OFF \
      -DBUILD_BENCHMARKS=OFF && \
    cmake --build /tmp/folly-src/_build -j$(nproc) && \
    cmake --install /tmp/folly-src/_build && \
    ldconfig && \
    rm -rf /tmp/folly-src
