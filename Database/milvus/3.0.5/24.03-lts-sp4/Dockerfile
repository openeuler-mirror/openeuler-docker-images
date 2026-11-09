ARG BASE=openeuler/openeuler:24.03-lts-sp4

# ---------------------------------------------------------------- toolchain
# Milvus 3.x needs a newer toolchain than what openEuler 24.03 LTS SP4
# ships: Go 1.26 (go.mod toolchain), Rust 1.92, Conan 2.x, CMake 3.26.
FROM ${BASE} AS toolchain

ARG TARGETARCH
ARG GO_VERSION=1.26.9
ARG CONAN_VERSION=2.25.1
# 1.92 is the default rustup toolchain: corrosion (milvus-storage's rust
# bridge) builds with the default toolchain and its dependencies
# (lance/vortex/iceberg) require rustc >= 1.91..1.92. The tantivy binding
# pins `cargo +1.89` internally and rustup installs that on demand.
ARG RUST_VERSION=1.92
ARG CMAKE_VERSION=3.26.5
ARG BUILD_JOBS=8

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    GOTOOLCHAIN=auto \
    jobs=${BUILD_JOBS} \
    CONAN_CPU_COUNT=${BUILD_JOBS} \
    CARGO_BUILD_JOBS=${BUILD_JOBS} \
    CARGO_NET_GIT_FETCH_WITH_CLI=true \
    CARGO_PROFILE_RELEASE_DEBUG=0 \
    LIBCLANG_PATH=/usr/lib64

RUN dnf -y install \
      gcc gcc-c++ gcc-gfortran libstdc++-static \
      make git hostname binutils \
      wget curl tar gzip unzip zip which findutils diffutils procps-ng \
      libaio-devel libuuid-devel openssl-devel zlib-devel libcurl-devel \
      libtool m4 autoconf automake pkgconf patch bzip2 perl \
      ninja-build ccache clang clang-libs \
      python3 python3-devel python3-pip \
      ca-certificates \
    && if ! command -v pkg-config >/dev/null 2>&1; then \
         ln -sf "$(command -v pkgconf)" /usr/local/bin/pkg-config; \
       fi \
    && dnf clean all

# Build tools must not inherit the OpenSSL built by Conan: system git links
# libcurl -> libldap -> libcrypto and Conan's OpenSSL 3.3 lacks EVP_md2.
# Wrap git so it always starts from a clean LD_LIBRARY_PATH.
RUN set -eux; \
    if [ ! -e /usr/bin/git.real ]; then mv /usr/bin/git /usr/bin/git.real; fi; \
    printf '%s\n' \
      '#!/bin/sh' \
      'unset LD_LIBRARY_PATH' \
      'unset LD_PRELOAD' \
      'exec /usr/bin/git.real "$@"' > /usr/bin/git; \
    chmod +x /usr/bin/git; \
    git --version

# The official CMake binary is statically linked against libcurl/libldap,
# which avoids the same OpenSSL ABI clash noted above.
RUN set -eux; \
    case "${TARGETARCH:-$(uname -m)}" in \
      amd64|x86_64) arch=x86_64 ;; \
      arm64|aarch64) arch=aarch64 ;; \
      *) echo "unsupported arch: ${TARGETARCH:-$(uname -m)}"; exit 1 ;; \
    esac; \
    curl -fsSL "https://cmake.org/files/v3.26/cmake-${CMAKE_VERSION}-linux-${arch}.tar.gz" -o /tmp/cmake.tgz; \
    mkdir -p /opt/cmake; \
    tar -C /opt/cmake --strip-components=1 -xzf /tmp/cmake.tgz; \
    ln -sf /opt/cmake/bin/cmake /usr/local/bin/cmake; \
    ln -sf /opt/cmake/bin/ctest /usr/local/bin/ctest; \
    ln -sf /opt/cmake/bin/cpack /usr/local/bin/cpack; \
    rm -f /tmp/cmake.tgz; \
    cmake --version | head -1

RUN set -eux; \
    case "${TARGETARCH:-$(uname -m)}" in \
      amd64|x86_64) goarch=amd64 ;; \
      arm64|aarch64) goarch=arm64 ;; \
      *) echo "unsupported arch: ${TARGETARCH:-$(uname -m)}"; exit 1 ;; \
    esac; \
    curl -fsSL "https://golang.google.cn/dl/go${GO_VERSION}.linux-${goarch}.tar.gz" -o /tmp/go.tgz; \
    tar -C /usr/local -xzf /tmp/go.tgz; \
    rm -f /tmp/go.tgz; \
    /usr/local/go/bin/go version
ENV PATH=/usr/local/go/bin:$PATH

# Milvus 3.x switched its third-party build to conan 2.x.
RUN set -eux; \
    python3 -m venv /opt/conan; \
    /opt/conan/bin/pip install --no-cache-dir "conan==${CONAN_VERSION}"; \
    /opt/conan/bin/conan profile detect --force; \
    printf '%s\n' '' '[conf]' "tools.build:jobs=${BUILD_JOBS}" >> /root/.conan2/profiles/default
ENV PATH=/opt/conan/bin:$PATH

RUN set -eux; \
    curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain "${RUST_VERSION}"; \
    /root/.cargo/bin/rustc --version
ENV PATH=/root/.cargo/bin:$PATH

RUN go version \
    && cmake --version | head -1 \
    && gcc --version | head -1 \
    && python3 -VV \
    && conan --version \
    && rustc --version \
    && pkg-config --version \
    && git --version

# ----------------------------------------------------------------- builder
FROM toolchain AS builder

ARG VERSION=3.0.5
ARG MILVUS_GIT_URL=https://github.com/milvus-io/milvus.git
ARG JEMALLOC_LG_PAGE=auto
ARG MINIO_RELEASE=RELEASE.2025-10-15T17-29-55Z

WORKDIR /milvus
RUN git clone --depth 1 --single-branch --branch "v${VERSION}" "${MILVUS_GIT_URL}" /milvus

# Upstream only needs cmake_build/thirdparty for its macOS Rust check.
RUN mkdir -p /milvus/cmake_build/thirdparty

# Patch scripts/3rdparty_build.sh: in pre_build(), skip the Conan-managed
# "openssl" and "libcurl" packages so that milvus and every build tool keep
# linking against the system libraries. Decoded patch does:
#   old = '        for dep in conanfile.dependencies.values():\n            if dep.package_folder:'
#   new = '        for dep in conanfile.dependencies.values():\n            if dep.ref.name in ("openssl", "libcurl"):\n                continue\n            if dep.package_folder:'
# and replaces the first occurrence in scripts/3rdparty_build.sh.
RUN echo 'cCA9ICcvbWlsdnVzL3NjcmlwdHMvM3JkcGFydHlfYnVpbGQuc2gnCnMgPSBvcGVuKHApLnJlYWQoKQpvbGQgPSAnICAgICAgICBmb3IgZGVwIGluIGNvbmFuZmlsZS5kZXBlbmRlbmNpZXMudmFsdWVzKCk6XG4gICAgICAgICAgICBpZiBkZXAucGFja2FnZV9mb2xkZXI6JwpuZXcgPSAnICAgICAgICBmb3IgZGVwIGluIGNvbmFuZmlsZS5kZXBlbmRlbmNpZXMudmFsdWVzKCk6XG4gICAgICAgICAgICBpZiBkZXAucmVmLm5hbWUgaW4gKCJvcGVuc3NsIiwgImxpYmN1cmwiKTpcbiAgICAgICAgICAgICAgICBjb250aW51ZVxuICAgICAgICAgICAgaWYgZGVwLnBhY2thZ2VfZm9sZGVyOicKaSA9IHMuZmluZChvbGQpCmFzc2VydCBpICE9IC0xCm9wZW4ocCwgJ3cnKS53cml0ZShzWzppXSArIG5ldyArIHNbaStsZW4ob2xkKTpdKQo=' | base64 -d | python3 -

# Build all third-party packages, then free the conan cache of build trees
# and package sources (~11GB with conan 2.25); only the binary packages in
# /root/.conan2/p/b/*/p are consumed by the core build later. Removing them
# inside the same RUN keeps the dead weight out of the image layer, small
# CI runners otherwise run out of disk during `make install`.
RUN set -eux; \
    make build-3rdparty; \
    rm -rf /root/.conan2/p/b/*/b \
           /root/.conan2/p/*/s \
           /root/.conan2/p/*/d

# jemalloc must match the page size of the target architecture
# (aarch64 uses 64K pages, x86_64 uses 4K pages).
RUN set -eux; \
    if [ "${JEMALLOC_LG_PAGE}" = "auto" ]; then \
      JEMALLOC_LG_PAGE=$(python3 -c "import math; print(int(math.log2($(getconf PAGESIZE))))"); \
    fi; \
    echo "PAGESIZE=$(getconf PAGESIZE), jemalloc lg-page=${JEMALLOC_LG_PAGE}, jobs=${jobs}"; \
    CMAKE_EXTRA_ARGS="-DMILVUS_JEMALLOC_LG_PAGE=${JEMALLOC_LG_PAGE}" make install SKIP_3RDPARTY=1

# Pinned MinIO release, built with the same Go toolchain instead of the
# unversioned dl.min.io latest download, so the image stays reproducible.
RUN mkdir -p /out && GOBIN=/out go install github.com/minio/minio@${MINIO_RELEASE}

# ---------------------------------------------------------------- runtime
FROM ${BASE}

ARG TARGETARCH

RUN dnf -y install \
      ca-certificates libaio libuuid openssl-libs zlib libcurl \
      libgomp libatomic libstdc++ openblas-devel libomp tzdata \
    && dnf clean all

RUN set -eux; \
    case "${TARGETARCH:-$(uname -m)}" in \
      amd64|x86_64) a=amd64 ;; \
      arm64|aarch64) a=arm64 ;; \
      *) echo "unsupported arch: ${TARGETARCH:-$(uname -m)}"; exit 1 ;; \
    esac; \
    curl -fSL -o /tmp/etcd.tar.gz "https://github.com/etcd-io/etcd/releases/download/v3.5.0/etcd-v3.5.0-linux-${a}.tar.gz"; \
    tar -C /tmp -xzf /tmp/etcd.tar.gz; \
    cp -r "/tmp/etcd-v3.5.0-linux-${a}" /usr/local/etcd; \
    rm -rf /tmp/etcd.tar.gz "/tmp/etcd-v3.5.0-linux-${a}"
ENV PATH=/usr/local/etcd:$PATH

COPY --from=builder /out/minio /usr/bin/minio

WORKDIR /milvus

RUN mkdir -p /milvus/lib64
COPY --from=builder /milvus/lib/ /milvus/lib/
COPY --from=builder /milvus/configs /milvus/configs
COPY --from=builder /milvus/bin/ /milvus/bin/

ENV LD_LIBRARY_PATH=/milvus/lib:/milvus/lib64:/lib64
ENV PATH=$PATH:/milvus/bin/
