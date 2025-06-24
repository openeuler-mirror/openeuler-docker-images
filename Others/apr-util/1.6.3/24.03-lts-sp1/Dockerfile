ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG VERSION=1.6.3
ARG APR_VERSION=1.7.6

RUN dnf update -y && \
    dnf install -y \
    wget \
    gcc \
    make \
    libtool \
    pkg-config \
    expat-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://dlcdn.apache.org/apr/apr-${APR_VERSION}.tar.gz \
    && tar -zxvf apr-${APR_VERSION}.tar.gz \
    && cd apr-${APR_VERSION} \
    && ./configure --prefix=/usr/local/apr \
    && make -j$(nproc) \
    && make install \
    && cd .. \
    && rm -rf apr-${APR_VERSION}*

RUN wget https://dlcdn.apache.org/apr/apr-util-${VERSION}.tar.gz \
    && tar -zxvf apr-util-${VERSION}.tar.gz \
    && cd apr-util-${VERSION} \
    && ./configure --prefix=/usr/local/apr --with-apr=/usr/local/apr \
    && make -j$(nproc) \
    && make install \
    && cd .. \
    && rm -rf apr-util-${VERSION}*

ENV LD_LIBRARY_PATH=/usr/local/apr/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH=/usr/local/apr/lib/pkgconfig:$PKG_CONFIG_PATH

CMD ["/usr/local/apr/bin/apu-1-config", "--version"]