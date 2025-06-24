ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=10.0.5

RUN dnf update -y \
    && dnf install -y wget gcc-c++ cmake brotli-devel xz-devel pcre-devel pcre2-devel zlib-devel openssl-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://github.com/apache/trafficserver/archive/refs/tags/10.0.5.tar.gz \
    && tar -zxvf 10.0.5.tar.gz \
    && rm -f 10.0.5.tar.gz

WORKDIR /opt/trafficserver-${VERSION}

RUN cmake -B build -DCMAKE_INSTALL_PREFIX=/usr/local/trafficserver \
    && cmake --build build \
    && cmake --install build

WORKDIR /usr/local/trafficserver

CMD ["./bin/traffic_server", "--help"]