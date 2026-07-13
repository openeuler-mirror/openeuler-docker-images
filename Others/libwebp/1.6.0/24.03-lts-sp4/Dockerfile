ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=1.6.0

RUN dnf install -y gcc-c++ make autoconf automake libtool wget \
        libpng-devel libjpeg-turbo-devel libtiff-devel giflib-devel freeglut-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

WORKDIR /opt

RUN wget https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-${VERSION}.tar.gz \
    && tar -zxf libwebp-${VERSION}.tar.gz \
    && rm -f libwebp-${VERSION}.tar.gz

WORKDIR /opt/libwebp-${VERSION}

RUN ./configure --prefix=/usr/local \
    && make -j$(nproc) \
    && make install

FROM ${BASE}

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/include /usr/local/include

RUN ldconfig

CMD ["cwebp", "-h"]
