ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as builder
ARG VERSION=2.3.3

RUN dnf update -y \
    && dnf install -y wget curl gcc openssl-devel libnl3-devel net-snmp-devel openssl-devel \
    autoconf automake libtool pkgconfig \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://github.com/acassen/keepalived/archive/refs/tags/v${VERSION}.tar.gz \
    && tar -zxvf v${VERSION}.tar.gz \
    && rm -f v${VERSION}.tar.gz

WORKDIR /opt/keepalived-${VERSION}

RUN ./autogen.sh \
    && ./configure \
    && make -j \
    && make install

CMD ["keepalived", "--help"]