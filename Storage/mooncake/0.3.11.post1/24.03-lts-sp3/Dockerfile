ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=0.3.11

WORKDIR /build

RUN dnf install -y --enablerepo=EPOL,everything \
        gcc gcc-c++ cmake make git \
        glog-devel gflags-devel jsoncpp-devel yaml-cpp-devel \
        libunwind-devel numactl-devel rdma-core-devel asio-devel \
        python3-devel && \
    dnf clean all

RUN git clone --depth 1 --branch v0.5.7 \
        https://github.com/alibaba/yalantinglibs.git yalantinglibs && \
    cmake -S yalantinglibs -B yalantinglibs/build \
        -DBUILD_EXAMPLES=OFF -DBUILD_BENCHMARK=OFF -DBUILD_UNIT_TESTS=OFF \
        -DCMAKE_BUILD_TYPE=Release && \
    cmake --install yalantinglibs/build && \
    rm -rf yalantinglibs

RUN git clone --depth 1 --branch v${VERSION}.post1 \
        --recurse-submodules --shallow-submodules \
        https://github.com/kvcache-ai/Mooncake.git mooncake && \
    cmake -S mooncake -B mooncake/build \
        -DBUILD_UNIT_TESTS=OFF \
        -DBUILD_BENCHMARK=OFF \
        -DUSE_ETCD=OFF \
        -DUSE_HTTP=OFF \
        -DUSE_REDIS=OFF \
        -DWITH_STORE=OFF \
        -DWITH_STORE_RUST=OFF \
        -DWITH_STORE_GO=OFF \
        -DWITH_P2P_STORE=OFF \
        -DWITH_EP=OFF \
        -DCMAKE_BUILD_TYPE=Release && \
    make -C mooncake/build -j$(nproc) && \
    find mooncake/build -type f \
        \( -name "transfer_engine_bench" \
        -o -name "transfer_engine_validator" \
        -o -name "transfer_engine_bench_with_notify" \) \
        -exec install -m 755 {} /usr/local/bin/ \; && \
    rm -rf mooncake

CMD ["transfer_engine_bench", "--help"]
