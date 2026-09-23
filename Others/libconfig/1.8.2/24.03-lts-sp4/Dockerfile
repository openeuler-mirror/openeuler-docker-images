ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=1.8.2

RUN dnf install -y \
      gcc gcc-c++ make \
      curl \
    && dnf clean all

WORKDIR /opt

RUN curl -fSL --connect-timeout 30 --max-time 600 --retry 3 --retry-delay 5 \
      -o libconfig-${VERSION}.tar.gz \
      https://hyperrealm.github.io/libconfig/dist/libconfig-${VERSION}.tar.gz \
    && tar -zxf libconfig-${VERSION}.tar.gz \
    && rm libconfig-${VERSION}.tar.gz

WORKDIR /opt/libconfig-${VERSION}

RUN ./configure --prefix=/usr/local --disable-doc \
    && make -j$(nproc) \
    && make install DESTDIR=/opt/libconfig \
    && mkdir -p /opt/libconfig/usr/local/share/licenses/libconfig \
    && cp COPYING.LIB /opt/libconfig/usr/local/share/licenses/libconfig/COPYING.LIB

FROM ${BASE}

ARG VERSION=1.8.2

RUN dnf install -y \
      gcc gcc-c++ make \
      pkgconf \
    && dnf clean all

COPY --from=builder /opt/libconfig/usr/local/ /usr/local/

RUN printf '/usr/local/lib\n' > /etc/ld.so.conf.d/libconfig.conf \
    && ldconfig

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

CMD ["bash"]

USER root
