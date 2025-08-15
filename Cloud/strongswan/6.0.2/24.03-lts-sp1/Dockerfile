ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=6.0.2

RUN dnf update -y \
    && dnf install -y wget gcc make gmp-devel openssl-devel libcurl-devel \
    openldap-devel libcap-ng-devel iproute iptables pkgconfig \
    autoconf automake libtool libtool-ltdl-devel m4 gettext gettext-devel \
    gperf flex bison \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://github.com/strongswan/strongswan/archive/refs/tags/${VERSION}.tar.gz \
    && tar -zxvf ${VERSION}.tar.gz \
    && rm -f ${VERSION}.tar.gz

WORKDIR /opt/strongswan-${VERSION}

RUN ./autogen.sh \
    && ./configure \
    && make -j \
    && make install

CMD ["swanctl", "--help"]