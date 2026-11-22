ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=1.4

RUN dnf install -y \
      gcc make \
    && dnf clean all

WORKDIR /opt

RUN curl -fSL --connect-timeout 30 --max-time 600 --retry 3 --retry-delay 5 \
      -o zlib-${VERSION}.tar.gz \
      https://github.com/madler/zlib/releases/download/v${VERSION}/zlib-${VERSION}.tar.gz \
    && echo "02dd159783677a749c04adbdd02b55b8a2bcc7e054f51b76b549199a916ad584  zlib-${VERSION}.tar.gz" | sha256sum -c - \
    && tar -zxf zlib-${VERSION}.tar.gz \
    && rm zlib-${VERSION}.tar.gz

WORKDIR /opt/zlib-${VERSION}

RUN ./configure --prefix=/usr/local \
    && make -j$(nproc) \
    && make install DESTDIR=/opt/zlib \
    && mkdir -p /opt/zlib/usr/local/share/licenses/zlib \
    && cp LICENSE /opt/zlib/usr/local/share/licenses/zlib/LICENSE

FROM ${BASE}

ARG VERSION=1.4

RUN dnf install -y \
      pkg-config \
    && dnf clean all

COPY --from=builder /opt/zlib/usr/local/ /usr/local/

RUN printf '/usr/local/lib\n' > /etc/ld.so.conf.d/zlib.conf \
    && ldconfig

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

USER root

CMD ["bash"]