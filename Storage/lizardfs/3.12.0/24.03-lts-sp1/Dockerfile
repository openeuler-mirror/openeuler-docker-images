ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=3.12.0

RUN yum install -y \
        fmt fmt-devel git gcc gcc-c++ fuse-devel cmake pkgconfig unzip spdlog-devel \
        zlib-devel asciidoc Judy-devel libdb-devel boost-devel pam-devel make && \
    yum clean all

RUN git clone https://github.com/lizardfs/lizardfs.git
WORKDIR /lizardfs
RUN sed -i "s/fsync(ctx, fileinfo)/fsync(ctx, fileinfo, ec)/g" src/mount/client/client.cc && \
    sed -i "s/readlink(ctx, inode)/readlink(ctx, inode, ec)/g" src/mount/client/client.cc && \
    ./configure && \
    make -j4 && \
    make install