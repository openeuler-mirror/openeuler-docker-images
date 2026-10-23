ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=36.2

# Abseil release pinned by protobuf v${VERSION} (see cmake/dependencies.cmake).
ARG ABSL_VERSION=20250512.1

RUN dnf install -y \
      cmake make gcc gcc-c++ \
      zlib-devel \
      && dnf clean all \
      && rm -rf /var/cache/dnf

WORKDIR /opt

# openEuler 24.03-LTS-SP4 ships abseil-cpp 20230802, which is older than the
# version the protobuf ${VERSION} C++ runtime requires: it needs abseil targets
# that only exist in newer LTS releases (absl::absl_check, absl::absl_log,
# absl::log_initialize, absl::log_globals, ...). Build the pinned release.
RUN curl -fSL --connect-timeout 30 --retry 3 -o absl.tar.gz \
      "https://github.com/abseil/abseil-cpp/archive/refs/tags/${ABSL_VERSION}.tar.gz" \
    && mkdir absl-src \
    && tar -xzf absl.tar.gz --strip-components=1 -C absl-src \
    && cmake -S absl-src -B absl-build \
         -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_INSTALL_PREFIX=/usr/local \
         -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
         -DBUILD_SHARED_LIBS=ON \
         -DABSL_ENABLE_INSTALL=ON \
         -DABSL_PROPAGATE_CXX_STD=ON \
         -DABSL_BUILD_TESTING=OFF \
    && cmake --build absl-build -j"$(nproc)" \
    && cmake --install absl-build \
    && rm -rf absl.tar.gz absl-src absl-build

# Build protoc, libprotobuf and the CMake package (protobuf-config.cmake)
# that consumers use through find_package(protobuf).
RUN curl -fSL --connect-timeout 30 --retry 3 -o protobuf.tar.gz \
      "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v${VERSION}.tar.gz" \
    && mkdir protobuf-src \
    && tar -xzf protobuf.tar.gz --strip-components=1 -C protobuf-src \
    && cmake -S protobuf-src -B protobuf-build \
         -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_INSTALL_PREFIX=/usr/local \
         -DCMAKE_PREFIX_PATH=/usr/local \
         -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
         -DBUILD_SHARED_LIBS=ON \
         -Dprotobuf_BUILD_SHARED_LIBS=ON \
         -Dprotobuf_BUILD_TESTS=OFF \
         -Dprotobuf_WITH_ZLIB=ON \
    && cmake --build protobuf-build -j"$(nproc)" \
    && cmake --install protobuf-build \
    && rm -rf protobuf.tar.gz protobuf-src protobuf-build

# Fail the build unless the installed CMake package really is consumable.
RUN mkdir -p /tmp/check \
    && printf '%s\n' \
         'cmake_minimum_required(VERSION 3.16)' \
         'project(protobuf_check CXX)' \
         'find_package(protobuf CONFIG REQUIRED)' \
         'add_executable(protobuf_check main.cc)' \
         'target_link_libraries(protobuf_check PRIVATE protobuf::libprotobuf)' \
         > /tmp/check/CMakeLists.txt \
    && printf '%s\n' \
         '#include <google/protobuf/descriptor.h>' \
         'int main() { return google::protobuf::DescriptorPool::generated_pool()->FindFileByName("google/protobuf/descriptor.proto") ? 0 : 1; }' \
         > /tmp/check/main.cc \
    && cmake -S /tmp/check -B /tmp/check/build -DCMAKE_PREFIX_PATH=/usr/local \
    && cmake --build /tmp/check/build -j"$(nproc)" \
    && LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64 /tmp/check/build/protobuf_check \
    && LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64 protoc --version \
    && rm -rf /tmp/check

FROM ${BASE}

# The image is also used to compile and run C++ programs that link against
# libprotobuf, so the toolchain has to survive into the final stage. Only the
# /usr/local tree is copied from the builder, hence install the packages again.
RUN dnf install -y \
      gcc-c++ \
      make \
      cmake \
      && dnf clean all \
      && rm -rf /var/cache/dnf

COPY --from=builder /usr/local /usr/local

RUN printf '/usr/local/lib\n/usr/local/lib64\n' > /etc/ld.so.conf.d/protobuf.conf \
    && ldconfig

USER root

CMD ["protoc", "--version"]
