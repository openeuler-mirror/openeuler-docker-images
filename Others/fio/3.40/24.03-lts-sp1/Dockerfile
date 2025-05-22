ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG VERSION=3.40

RUN dnf update -y && \
    dnf install -y \
    wget \
    gcc \
    make \
    libaio-devel \
    cairo-devel \
    gtk3-devel \
    openssl-devel \
    curl-devel \
    zlib-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

WORKDIR /opt

RUN wget https://github.com/axboe/fio/archive/refs/tags/fio-${VERSION}.tar.gz \
    && tar -zxvf fio-${VERSION}.tar.gz \
    && rm -f fio-${VERSION}.tar.gz

WORKDIR /opt/fio-fio-${VERSION}

RUN ./configure --prefix=/usr/local \
    && make -j$(nproc) \
    && make install

CMD ["fio"]
