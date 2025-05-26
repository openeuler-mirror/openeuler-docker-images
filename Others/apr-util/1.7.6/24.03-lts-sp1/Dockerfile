ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG VERSION=1.7.6

RUN dnf update -y && \
    dnf install -y \
    wget \
    gcc \
    make \
    libtool \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

WORKDIR /opt

RUN wget https://dlcdn.apache.org/apr/apr-${VERSION}.tar.gz \
    && tar -zxvf apr-${VERSION}.tar.gz \
    && rm -f apr-${VERSION}.tar.gz

WORKDIR /opt/apr-${VERSION}

RUN ./configure \
    && make -j$(nproc) \
    && make install

CMD ["/usr/local/apr/bin/apr-1-config"]
