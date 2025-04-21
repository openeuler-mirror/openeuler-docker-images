ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=4.57.5

RUN yum install -y git make gcc zlib-devel automake autoconf m4 && \
    ln -s /usr/bin/automake /usr/bin/automake-1.17 && \
    yum clean all

RUN git clone -b v${VERSION} https://github.com/moosefs/moosefs.git && \
    cd moosefs && \
    ./linux_build.sh