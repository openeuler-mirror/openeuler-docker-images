ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}

ARG VERSION=4.58.0

RUN yum install -y git make gcc zlib-devel automake autoconf m4 && \
    ln -s /usr/bin/automake /usr/bin/automake-1.18 && \
    yum clean all

RUN git clone -b v${VERSION} https://github.com/moosefs/moosefs.git && \
    cd moosefs && \
    ./linux_build.sh