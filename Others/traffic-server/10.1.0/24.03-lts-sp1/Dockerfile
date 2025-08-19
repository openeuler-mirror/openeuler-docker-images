ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=10.1.0

RUN dnf update -y \
    && dnf install -y wget gcc-c++ cmake shadow-utils brotli-devel xz-devel pcre-devel pcre2-devel zlib-devel openssl-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://github.com/apache/trafficserver/archive/refs/tags/10.1.0.tar.gz \
    && tar -zxvf 10.1.0.tar.gz \
    && rm -f 10.1.0.tar.gz

WORKDIR /opt/trafficserver-${VERSION}

RUN cmake -B build -DCMAKE_INSTALL_PREFIX=/usr/local/trafficserver \
    && cmake --build build -- -j$(nproc) \
    && cmake --install build

COPY remap.config /usr/local/trafficserver/etc/trafficserver/remap.config
COPY records.yaml /usr/local/trafficserver/etc/trafficserver/records.yaml

WORKDIR /usr/local/trafficserver

RUN useradd -r -s /sbin/nologin trafficserver

RUN mkdir -p /usr/local/trafficserver/var/trafficserver && \
    chown -R trafficserver:trafficserver /usr/local/trafficserver/var && \
    chmod 750 /usr/local/trafficserver/var

USER trafficserver

EXPOSE 8080

CMD ["bin/traffic_server", "-T", "misc"]