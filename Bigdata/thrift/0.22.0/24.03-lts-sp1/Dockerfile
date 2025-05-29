ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=0.22.0

RUN yum install -y make gcc g++ libtool byacc flex python3-devel python3-pip && \
    yum clean all && \
    curl -fSL -o thrift.tar.gz https://github.com/apache/thrift/archive/refs/tags/v${VERSION}.tar.gz; \
    mkdir -p /thrift && \
    tar -zxf thrift.tar.gz -C /thrift --strip-components=1 && \
    rm -rf thrift.tar.gz

WORKDIR /thrift
RUN ./bootstrap.sh && ./configure && \
    make -j$nproc && make install

ENTRYPOINT ["thrift", "--version"]
