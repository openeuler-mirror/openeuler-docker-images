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
        snappy snappy-devel lz4 lz4-devel curl-devel leveldb-devel \
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
RUN git clone -b v${VERSION} --recursive --depth 1 https://github.com/ceph/ceph.git \
    && cd ceph \
    && ./do_cmake.sh -DCMAKE_BUILD_TYPE=Release -DWITH_TESTS=OFF \
    && cd build \
    && ninja -j$(nproc) \
    && ninja install

ENV LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH

COPY --chmod=755 entrypoint.sh /opt/ceph/entrypoint.sh

WORKDIR /opt/ceph

ENTRYPOINT [ "./entrypoint.sh" ]
