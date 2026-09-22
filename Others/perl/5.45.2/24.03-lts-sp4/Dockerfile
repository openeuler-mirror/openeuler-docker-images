ARG BASE=openeuler/openeuler:24.03-lts-sp4
ARG VERSION=5.45.2

FROM ${BASE} AS builder

ARG VERSION

RUN dnf install -y \
      gcc make \
      zlib-devel bzip2-devel gdbm-devel libxcrypt-devel && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 --retry-delay 5 \
      -o /tmp/perl-${VERSION}.tar.gz \
      https://github.com/Perl/perl5/archive/refs/tags/v${VERSION}.tar.gz && \
    tar -xzf /tmp/perl-${VERSION}.tar.gz -C /tmp && \
    cd /tmp/perl5-${VERSION} && \
    ./Configure -des -Dusedevel -Dversiononly=no -Dprefix=/usr/local && \
    make -j"$(nproc)" && \
    make install && \
    rm -rf /tmp/*

FROM ${BASE}

COPY --from=builder /usr/local /usr/local

USER root
