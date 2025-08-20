ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG VERSION=3.3.7.3

RUN yum install -y git cmake gcc gcc-c++ make pkgconfig openssl-devel maven golang \
    zlib-devel zlib-static snappy-devel xz-devel jansson-devel \
    libatomic-static libstdc++-static tree autoconf automake patch && \
    yum clean all

RUN git clone -b ver-${VERSION} https://github.com/taosdata/TDengine.git

COPY build.sh /TDengine/build.sh
COPY cmake_curl.patch /TDengine/cmake_curl.patch

WORKDIR TDengine

RUN patch -Np1 < cmake_curl.patch && \
    chmod 755 build.sh && \
    ./build.sh