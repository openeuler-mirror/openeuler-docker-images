ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=1.5.7

RUN dnf install -y \
      gcc make \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN curl -fSL --connect-timeout 30 --max-time 600 --retry 3 --retry-delay 5 \
      -o zstd-${VERSION}.tar.gz \
      https://github.com/facebook/zstd/releases/download/v${VERSION}/zstd-${VERSION}.tar.gz \
    && echo "eb33e51f49a15e023950cd7825ca74a4a2b43db8354825ac24fc1b7ee09e6fa3  zstd-${VERSION}.tar.gz" | sha256sum -c - \
    && tar -zxf zstd-${VERSION}.tar.gz \
    && rm zstd-${VERSION}.tar.gz

WORKDIR /opt/zstd-${VERSION}

# The two targets are built one after the other: in parallel each of them would
# compile the library sources into the same object directory.
RUN make -j$(nproc) lib-release \
    && make -j$(nproc) zstd-release \
    && make -C lib install DESTDIR=/opt/zstd \
    && make -C programs install DESTDIR=/opt/zstd \
    && mkdir -p /opt/zstd/usr/local/share/licenses/zstd \
    && cp LICENSE /opt/zstd/usr/local/share/licenses/zstd/LICENSE \
    && cp COPYING /opt/zstd/usr/local/share/licenses/zstd/COPYING

FROM ${BASE}

COPY --from=builder /opt/zstd/usr/local/ /usr/local/

RUN printf '/usr/local/lib\n' > /etc/ld.so.conf.d/zstd.conf \
    && ldconfig

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

USER root

CMD ["bash"]
