ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=1.11.0
ARG TARGETARCH
ARG BUILDARCH

WORKDIR /

RUN yum install -y \
    wget maven \
    python-six python-virtualenv \
    java-devel zlib-devel libcurl-devel \
    cyrus-sasl-devel cyrus-sasl-md5 \
    apr-devel subversion-devel apr-util-devel \
    gcc make libtool libsysfs \
    patch g++

RUN wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2k.tar.gz && \
    tar -zxvf openssl-1.0.2k.tar.gz && \
    cd openssl-1.0.2k && \
    ./config shared --prefix=/usr/local/openssl-1.0.2k && \
    make -j$(nproc) && make install

COPY pysetup.patch /
RUN wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz && \
    tar -zxvf Python-2.7.18.tgz && \
    cd Python-2.7.18 && \
    patch Modules/Setup.dist < /pysetup.patch && \
    ./configure \
        --prefix=/usr/local/python-2.7 \
        --enable-unicode=ucs4 \
        --enable-shared \
        LDFLAGS="-L/usr/local/openssl-1.0.2k/lib" \
        CPPFLAGS="-I/usr/local/openssl-1.0.2k/include" \
        LD_LIBRARY_PATH=/usr/local/openssl-1.0.2k/lib && \
        make -j$(nproc) && make install && \
        ln -s /usr/local/python-2.7/bin/python /usr/bin/python2

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/python-2.7/lib/:/usr/local/openssl-1.0.2k/lib
RUN wget https://downloads.apache.org/mesos/${VERSION}/mesos-${VERSION}.tar.gz && \
    tar -zxf mesos-${VERSION}.tar.gz
COPY grpc-1.10.0.patch /mesos-${VERSION}/3rdparty/grpc-1.10.0.patch
RUN cd /mesos-${VERSION} && \
    CXXFLAGS="-Wno-nonnull -Wno-deprecated-declarations -Wno-parentheses" ./configure && \
    make -j 8 && make install

ENV PATH $PATH:/mesos/bin
COPY entrypoint.sh /

EXPOSE 5050 5051

ENTRYPOINT ["/entrypoint.sh"]
