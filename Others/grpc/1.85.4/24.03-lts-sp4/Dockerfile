ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=1.85.4
ARG WORK_HOME=/home/grpc

RUN dnf install -y \
        git \
        gcc \
        gcc-c++ \
        make \
        cmake \
        perl \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

# Build the upstream gRPC C++ core together with its pinned third_party
# submodules (abseil, protobuf, boringssl, re2, c-ares, ...).
RUN git clone -b v${VERSION} --depth 1 --recurse-submodules \
        https://github.com/grpc/grpc ${WORK_HOME}

WORKDIR ${WORK_HOME}/cmake/build

RUN cmake ../.. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_STANDARD=17 \
        -DgRPC_INSTALL=ON \
        -DgRPC_BUILD_TESTS=OFF \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
    && make -j"$(nproc)" \
    && make install

# Build the C++ hello-world example against the freshly installed gRPC.
WORKDIR ${WORK_HOME}/examples/cpp/helloworld/cmake/build

RUN cmake ../.. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_STANDARD=17 \
        -DCMAKE_PREFIX_PATH=/usr/local \
    && make -j"$(nproc)"

# Keep only the example binaries and the upstream version header, then drop the
# sources, installed archives and codegen tools that are not needed at runtime.
RUN install -m 0755 greeter_server greeter_client /usr/local/bin/ \
    && mkdir -p /usr/local/share/grpc \
    && install -m 0644 /usr/local/include/grpcpp/version_info.h /usr/local/share/grpc/version_info.h \
    && rm -rf ${WORK_HOME} \
        /usr/local/include \
        /usr/local/lib \
        /usr/local/share/grpc/cmake \
        /usr/local/bin/protoc \
        /usr/local/bin/grpc_*_plugin

WORKDIR /

EXPOSE 50051

CMD ["/usr/local/bin/greeter_server"]
