ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=2.4.1
ENV TENGINE_URL=https://tengine.taobao.org/download/tengine-${VERSION}.tar.gz

RUN yum install -y gcc make zlib-devel pcre-devel openssl-devel jemalloc-devel chkconfig && \
    yum clean all

WORKDIR /tengine

RUN curl -fSL -o tengine.tar.gz ${TENGINE_URL} && \
    tar -xzf tengine.tar.gz --strip-components=1 && \
    rm tengine.tar.gz

RUN ./configure --prefix=/usr/local/nginx --with-jemalloc && \
    make -j$nproc && \
    make install && \
    rm -rf /tengine
