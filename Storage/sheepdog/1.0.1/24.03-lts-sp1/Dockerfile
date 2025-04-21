ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=1.0.1

RUN yum install -y git gcc make g++ autoconf libtool automake
RUN git clone -b v${VERSION} https://github.com/sheepdog/sheepdog.git

WORKDIR /sheepdog
RUN yum install -y userspace-rcu-devel corosync corosynclib corosynclib-devel

COPY sha1.patch /
RUN git apply /sha1.patch && \
    ./autogen.sh && \
    ./configure \
        --without-initddir \
        --without-systemdsystemunitdir \
        --disable-static && \
    make -j$(nproc) && \
    make check && make install