ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=1.0.20

RUN dnf update -y \
    && dnf install -y wget make automake libtool pkgconfig libaio-devel \
    mariadb-devel openssl-devel \
    postgresql-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN wget https://github.com/akopytov/sysbench/archive/refs/tags/${VERSION}.tar.gz \
    && tar -zxvf ${VERSION}.tar.gz \
    && rm -f ${VERSION}.tar.gz \
    && cd sysbench-${VERSION} \
    && ./autogen.sh \
    && ./configure \
    && make -j \
    && make install

CMD ["sysbench", "--help"]