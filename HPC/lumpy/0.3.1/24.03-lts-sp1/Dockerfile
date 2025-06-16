ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=0.3.1

RUN yum install -y git make gcc g++ clang automake zlib-devel libcurl-devel openssl-devel && \
    yum clean all

WORKDIR /opt/
# install required autoconf version
RUN rpm -e --nodeps autoconf && \
    curl -O -L http://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.gz && \
    tar -xzf autoconf-2.69.tar.gz && rm -rf autoconf-2.69.tar.gz && \
    cd autoconf-2.69 && \
    ./configure && \
    make && make install 

COPY lumpy.patch /opt/
RUN git clone --recursive -b v${VERSION} https://github.com/arq5x/lumpy-sv.git && \
    cd /opt/lumpy-sv/lib/htslib/ && \
    autoreconf -i && ./configure --disable-bz2 --disable-lzma --enable-libcurl && \
    make && make install && \
    cd /opt/lumpy-sv && \
    mv /opt/lumpy.patch ./ && \
    git apply lumpy.patch && \
    make && cp bin/* /usr/local/bin/
