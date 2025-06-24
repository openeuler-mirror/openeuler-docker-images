ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=1.2.5

RUN dnf install -y \
    wget \
    gcc-c++ \
    make \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

WORKDIR /opt

RUN wget https://musl.libc.org/releases/musl-${VERSION}.tar.gz \
    && tar -zxvf musl-${VERSION}.tar.gz \
    && rm -f musl-${VERSION}.tar.gz

WORKDIR /opt/musl-${VERSION}

RUN ./configure \
    && make -j$(nproc) \
    && make install

ENV PATH=/usr/local/musl/bin:$PATH

CMD ["musl-gcc", "--help"]
