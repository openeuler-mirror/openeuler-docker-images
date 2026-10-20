ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE as builder
ARG VERSION=16.2.8

RUN dnf update -y \
    && dnf install -y \
        git gcc-c++ ninja-build cmake python3-sphinx \
        libibverbs libibverbs-devel rdma-core rdma-core-devel \
        systemd-devel libblkid-devel keyutils-libs-devel \
        openldap-devel cryptsetup-devel python3-pip \
        autoconf automake libtool ocaml ocaml-devel \
        libatomic librdkafka librdkafka-devel \
        gnutls-devel libxml2-devel glib2-devel \
        libev-devel fuse3-devel bash-completion \
        ocaml-findlib python3-devel golang rust cargo \
        libaio libaio-devel sqlite sqlite-devel \
        snappy snappy-devel lz4 lz4-devel curl-devel leveldb-devel boost-devel \
        expat-devel liboath liboath-devel lttng-ust lttng-ust-devel \
        babeltrace libbabeltrace-devel libicu libicu-devel \
        thrift-devel libcap-devel lua-devel \
        libcap-ng libcap-ng-devel gperf lmdb lmdb-devel \
        librabbitmq librabbitmq-devel python3-pyyaml \
        numactl-devel make python nasm \
    && dnf clean all

RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install cython prettytable

WORKDIR /opt

# 注意：与仓库里较新的 ceph 镜像（20.3.0 / 21.3.0）不同，ceph 16.2.8 不依赖 libnbd ——
# v16.2.8 中 src/tools/rbd_nbd 是基于内核 netlink（nl::genl）实现的，
# CMakeLists.txt 与 cmake/modules 中都没有任何 libnbd 引用。因此这里刻意不做 libnbd 源码构建。
# 另外，v16.2.8 的 do_cmake.sh 不会自动加 -G Ninja（20.3.0 才默认 -GNinja），
# 不显式指定会生成 Unix Makefiles，导致后面的 ninja 找不到 build.ninja。
# -DWITH_SYSTEM_BOOST=ON：ceph 的 WITH_SYSTEM_BOOST 默认为 OFF，会走 cmake/modules/BuildBoost.cmake
# 用 ExternalProject 从源码编 Boost，其产物 boost/lib/libboost_thread.a 没有声明 BUILD_BYPRODUCTS，
# ninja 加载依赖图时会报 "missing and no known rule to make it"。改用 openEuler 自带的 boost-devel(1.83) 即可。
# 再用系统 boost 1.83 的瘦身后发现 src/include/buffer.h 用了 std::unique_ptr 却没包含 <memory>，
# 旧版 libstdc++ / bundled boost 会间接带上该头文件，这里显式补上；
# src/rgw/rgw_string.h 同理（用了 std::string / std::invalid_argument，rgw_string.cc 用了 tolower）。
# 上游 16.2.15 起已为 buffer.h 补 <memory>、为 rgw_string.h 补 <string>/<stdexcept>，这里做等价回移。
RUN git clone -b v${VERSION} --recursive --depth 1 https://github.com/ceph/ceph.git \
    && cd ceph \
    && sed -i 's|^#define CEPH_BUFFER_H$|#define CEPH_BUFFER_H\n#include <memory>|' src/include/buffer.h \
    && sed -i 's|^#define CEPH_RGW_STRING_H$|#define CEPH_RGW_STRING_H\n#include <cctype>\n#include <stdexcept>\n#include <string>|' src/rgw/rgw_string.h \
    && ./do_cmake.sh -DCMAKE_BUILD_TYPE=Release -DWITH_TESTS=OFF \
        -DWITH_SYSTEM_BOOST=ON -GNinja \
    && cd build \
    && ninja -j$(nproc) \
    && ninja install

ENV LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH

COPY --chmod=755 entrypoint.sh /opt/ceph/entrypoint.sh

WORKDIR /opt/ceph

ENTRYPOINT [ "./entrypoint.sh" ]
