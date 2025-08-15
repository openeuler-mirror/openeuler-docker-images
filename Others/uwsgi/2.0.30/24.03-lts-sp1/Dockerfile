ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=2.0.30

RUN dnf update -y \
    && dnf install -y wget python3-devel gcc make libffi-devel zlib-devel openssl-devel \
    pcre-devel systemd-devel libuuid-devel libcap-devel libxml2-devel libyaml-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://github.com/unbit/uwsgi/archive/refs/tags/${VERSION}.tar.gz \
    && tar -zxvf ${VERSION}.tar.gz \
    && rm -f ${VERSION}.tar.gz \
    && mv uwsgi-* uwsgi

WORKDIR /opt/uwsgi

RUN make -j

CMD ["./uwsgi", "--help"]