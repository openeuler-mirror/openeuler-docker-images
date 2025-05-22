ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=8.2504.0

RUN dnf update -y \
    && dnf install -y wget gcc make libtool autoconf automake bison flex \
    python3-docutils zlib-devel json-c-devel libuuid-devel  \
    libgcrypt-devel libfastjson-devel libestr-devel  \
    libcurl-devel mysql-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN wget https://www.rsyslog.com/files/download/rsyslog/rsyslog-${VERSION}.tar.gz \
    && tar -zxvf rsyslog-${VERSION}.tar.gz \
    && rm -f rsyslog-${VERSION}.tar.gz \
    && cd  rsyslog-${VERSION} \
    && ./configure --enable-mysql \
    && make -j $(nproc) \
    && make install

CMD ["bash"]