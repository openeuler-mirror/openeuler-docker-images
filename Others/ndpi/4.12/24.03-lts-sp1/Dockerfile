ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=4.12

RUN yum install -y git make gcc autoconf automake libtool libpcap-devel
RUN git clone -b ${VERSION} https://github.com/ntop/nDPI.git && \
    cd nDPI && \
    ./autogen.sh && \
    make