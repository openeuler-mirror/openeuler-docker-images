ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=3.1.7

RUN dnf update -y \
    && dnf install -y wget gcc make openssl-devel pcre2-devel lua-devel zlib-devel systemd-devel \
    && dnf clean all

WORKDIR /opt

RUN wget https://www.haproxy.org/download/3.1/src/haproxy-${VERSION}.tar.gz \
    && tar -zxvf haproxy-${VERSION}.tar.gz \
    && rm -f haproxy-${VERSION}.tar.gz

WORKDIR /opt/haproxy-${VERSION}

RUN make clean \
    && make -j $(nproc) TARGET=linux-glibc USE_OPENSSL=1 USE_QUIC=1 USE_QUIC_OPENSSL_COMPAT=1 USE_LUA=1 USE_PCRE2=1 \
    && make install

CMD ["haproxy", "--help"]