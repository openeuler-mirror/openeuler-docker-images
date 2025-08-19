ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=3.9.3.0

RUN yum install -y git gcc cmake g++ libtool pkgconfig autoconf automake \
        m4 libdnet-devel flex hwloc-devel libpcap-devel zlib-devel pcre2-devel \
        luajit-devel openssl-devel xz-devel && \
    yum clean all

RUN git clone -b v3.0.21 https://github.com/snort3/libdaq.git && \
    cd libdaq && \
    ./bootstrap && ./configure && \
    make -j$nproc && make install

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/daq
RUN git clone -b ${VERSION} https://github.com/snort3/snort3.git && \
    cd snort3 && \
    ./configure_cmake.sh --prefix=/usr/local && \
    cd build && \
    make -j $(nproc) install
