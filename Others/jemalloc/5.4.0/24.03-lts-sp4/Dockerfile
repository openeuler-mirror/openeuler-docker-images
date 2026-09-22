ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=5.4.0

RUN dnf install -y \
      gcc make \
    && dnf clean all

WORKDIR /opt

RUN curl -fSL --connect-timeout 30 --max-time 600 --retry 3 --retry-delay 5 \
      -o jemalloc-${VERSION}.tar.bz2 \
      https://github.com/jemalloc/jemalloc/releases/download/${VERSION}/jemalloc-${VERSION}.tar.bz2 \
    && tar -xjf jemalloc-${VERSION}.tar.bz2 \
    && rm jemalloc-${VERSION}.tar.bz2

WORKDIR /opt/jemalloc-${VERSION}

RUN ./configure --prefix=/usr/local \
    && make -j$(nproc) \
    && make install DESTDIR=/opt/jemalloc

FROM ${BASE}

ARG VERSION=5.4.0

RUN dnf install -y \
      gcc make \
    && dnf clean all

COPY --from=builder /opt/jemalloc/usr/local/ /usr/local/

RUN printf '/usr/local/lib\n' > /etc/ld.so.conf.d/jemalloc.conf \
    && ldconfig

ENV LD_LIBRARY_PATH=/usr/local/lib

CMD ["bash"]

USER root
