ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=3.3.6.0

RUN yum install -y git cmake gcc gcc-c++ make pkgconfig openssl-devel maven golang \
    zlib-devel zlib-static snappy-devel xz-devel jansson-devel \
    libatomic-static libstdc++-static tree autoconf automake && \
    yum clean all

RUN git clone -b ver-${VERSION} https://github.com/taosdata/TDengine.git
COPY build.sh /TDengine/build.sh
COPY curl_CMakeLists.txt.in /TDengine/cmake/curl_CMakeLists.txt.in
RUN cd TDengine && \
    chmod 755 build.sh && \
    ./build.sh