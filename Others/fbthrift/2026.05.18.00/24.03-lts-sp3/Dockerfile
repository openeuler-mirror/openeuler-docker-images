ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG FBTHRIFT_VERSION=v2026.05.18.00

RUN dnf install -y \
        git gcc gcc-c++ make cmake \
        flex bison libtool \
        openssl-devel libevent-devel boost-devel zlib-devel \
        double-conversion-devel glog-devel gflags-devel fmt-devel \
        lz4-devel LZMA-SDK-devel snappy-devel libsodium-devel \
        python3 && \
    dnf clean all

COPY libaio-libaio-0.3.113.tar.gz /tmp/libaio.tar.gz
COPY fix_getdeps.py /tmp/fix_getdeps.py

RUN git clone -b ${FBTHRIFT_VERSION} --depth 1 https://github.com/facebook/fbthrift.git /build && \
    cd /build && \
    mkdir -p /tmp/fbcode_builder_getdeps-ZbuildZbuildZfbcode_builder-root/downloads && \
    cp /tmp/libaio.tar.gz /tmp/fbcode_builder_getdeps-ZbuildZbuildZfbcode_builder-root/downloads/libaio-libaio-libaio-0.3.113.tar.gz && \
    python3 /tmp/fix_getdeps.py && \
    ./build/fbcode_builder/getdeps.py --allow-system-packages --install-prefix /usr/local build fbthrift

ENV PATH=/usr/local/fbthrift/bin:$PATH