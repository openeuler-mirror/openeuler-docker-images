ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=2.1.2

RUN dnf install -y \
      gcc gcc-c++ make automake autoconf libtool \
      boost-devel zlib-devel ncurses-devel \
      curl && \
    dnf clean all

RUN curl -fSL https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz -o /tmp/py27.tgz && \
    tar -zxf /tmp/py27.tgz -C /tmp && rm /tmp/py27.tgz && \
    cd /tmp/Python-2.7.18 && \
    ./configure --prefix=/usr/local/python27 --enable-shared && \
    make -j$(nproc) && make install && \
    echo /usr/local/python27/lib > /etc/ld.so.conf.d/python27.conf && ldconfig && \
    ln -sf /usr/local/python27/bin/python2 /usr/bin/python && \
    cd / && rm -rf /tmp/Python-2.7.18

RUN mkdir -p /tmp/tophat-build && \
    curl -fSL https://github.com/DaehwanKimLab/tophat/archive/refs/tags/v${VERSION}.tar.gz | tar xz --strip-components=1 -C /tmp/tophat-build

WORKDIR /tmp/tophat-build

RUN sed -i 's/make_pair<Junction, JunctionStats>/make_pair/' src/tophat_reports.cpp && \
    sed -i '8s/.*//' configure.ac && \
    autoreconf -fiv && \
    ./configure --prefix=/usr/local \
        CC="gcc -fcommon" \
        CXX="g++ -std=gnu++14 -fcommon -fpermissive" && \
    make -j$(nproc) && \
    make install && \
    cd / && rm -rf /tmp/tophat-build

WORKDIR /data

CMD ["tophat2", "--help"]
