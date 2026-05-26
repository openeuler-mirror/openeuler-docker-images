ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=1.16.0
RUN yum install -y \
        git gcc gcc-c++ make cmake which \
        openssl-devel \
        gflags-devel \
        protobuf-devel protobuf-compiler \
        abseil-cpp-devel \
        leveldb-devel snappy-devel && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone -b ${VERSION} https://github.com/apache/brpc.git /brpc
WORKDIR /brpc/build
RUN cmake .. \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_BUILD_TYPE=Release \
        -DWITH_GFLAGS=ON \
        -DWITH_PROTOBUF=ON \
        -DWITH_LEVELDB=ON \
        -DWITH_SNAPPY=ON \
        -DWITH_OPENSSL=ON && \
    make -j $(nproc) && \
    make install
WORKDIR /workspace
CMD ["/bin/bash"]