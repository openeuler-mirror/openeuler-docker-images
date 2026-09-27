ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=1.10.0

RUN dnf install -y \
      gcc make \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN curl -fSL --connect-timeout 30 --max-time 600 --retry 3 --retry-delay 5 \
      -o lz4-${VERSION}.tar.gz \
      https://github.com/lz4/lz4/releases/download/v${VERSION}/lz4-${VERSION}.tar.gz \
    && echo "537512904744b35e232912055ccf8ec66d768639ff3abe5788d90d792ec5f48b  lz4-${VERSION}.tar.gz" | sha256sum -c - \
    && tar -zxf lz4-${VERSION}.tar.gz \
    && rm lz4-${VERSION}.tar.gz

WORKDIR /opt/lz4-${VERSION}

RUN make -j$(nproc) \
    && make install DESTDIR=/opt/lz4 \
    && mkdir -p /opt/lz4/usr/local/share/licenses/lz4 \
    && cp LICENSE /opt/lz4/usr/local/share/licenses/lz4/LICENSE \
    && cp lib/LICENSE /opt/lz4/usr/local/share/licenses/lz4/LICENSE.library \
    && cp programs/COPYING /opt/lz4/usr/local/share/licenses/lz4/COPYING

FROM ${BASE}

ARG VERSION=1.10.0

COPY --from=builder /opt/lz4/usr/local/ /usr/local/

RUN printf '/usr/local/lib\n' > /etc/ld.so.conf.d/lz4.conf \
    && ldconfig

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

USER root

CMD ["bash"]
