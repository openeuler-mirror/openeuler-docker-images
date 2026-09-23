ARG BASE=openeuler/openeuler:24.03-lts-sp4
ARG VERSION=8.5.10

FROM ${BASE} AS builder

ARG VERSION

RUN dnf install -y \
      gcc gcc-c++ make perl findutils \
      pkgconf \
      libxml2-devel sqlite-devel libcurl-devel openssl-devel \
      oniguruma-devel libargon2-devel libsodium-devel \
      readline-devel zlib-devel \
      xz && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 --retry-delay 5 \
      -o /tmp/php-${VERSION}.tar.xz \
      https://www.php.net/distributions/php-${VERSION}.tar.xz && \
    echo "6a8bebaa4d5a979a38db29a9373e9851f60c6b11f72172c585947e78f3081957  /tmp/php-${VERSION}.tar.xz" | sha256sum -c - && \
    mkdir -p /usr/src/php && \
    tar -xJf /tmp/php-${VERSION}.tar.xz -C /usr/src/php --strip-components=1 && \
    rm -f /tmp/php-${VERSION}.tar.xz

RUN cd /usr/src/php && \
    ./configure \
      --prefix=/usr/local \
      --with-libdir=lib64 \
      --sysconfdir=/usr/local/etc \
      --with-config-file-path=/usr/local/etc/php \
      --with-config-file-scan-dir=/usr/local/etc/php/conf.d \
      --enable-option-checking=fatal \
      --with-mhash \
      --with-pic \
      --enable-mbstring \
      --enable-mysqlnd \
      --with-mysqli=mysqlnd \
      --with-pdo-mysql=mysqlnd \
      --with-password-argon2 \
      --with-sodium \
      --with-pdo-sqlite=/usr \
      --with-sqlite3=/usr \
      --with-curl \
      --with-iconv \
      --with-openssl \
      --with-readline \
      --with-zlib \
      --enable-phpdbg \
      --enable-phpdbg-readline \
      --with-pear && \
    make -j"$(nproc)" && \
    make install && \
    mkdir -p /usr/local/etc/php/conf.d && \
    cp php.ini-production /usr/local/etc/php/php.ini && \
    rm -rf /usr/src/php

FROM ${BASE}

RUN dnf install -y \
      oniguruma libargon2 libsodium && \
    dnf clean all

COPY --from=builder /usr/local /usr/local

RUN ldconfig

USER root

CMD ["php", "-a"]
