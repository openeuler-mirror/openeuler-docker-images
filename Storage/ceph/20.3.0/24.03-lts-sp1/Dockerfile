ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE as builder
ARG VERSION=20.3.0

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
        snappy snappy-devel lz4 lz4-devel curl-devel \
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

RUN git clone https://gitlab.com/nbdkit/libnbd.git \
    && cd libnbd  \
    && autoreconf -fi \
    && ./configure \
    && make -j$(nproc) \
    && make install \
    && cd ..  \
    && rm -rf libnbd

RUN git clone -b v${VERSION} --recursive --depth 1 https://github.com/ceph/ceph.git \
    && cd ceph \
    && ./do_cmake.sh -DCMAKE_BUILD_TYPE=Release -DWITH_TESTS=OFF \
    && cd build \
    && ninja -j$(nproc) \
    && ninja install

ENV LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH

CMD ["ceph", "--help"]
