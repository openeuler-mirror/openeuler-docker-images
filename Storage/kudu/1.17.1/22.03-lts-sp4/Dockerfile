ARG BASE=openeuler/openeuler:22.03-lts-sp4
FROM ${BASE} AS build

ARG VERSION=1.17.1

RUN yum install -y autoconf automake cyrus-sasl-devel cyrus-sasl-gssapi cyrus-sasl-plain \
    flex gcc gcc-c++ gdb git java-1.8.0-openjdk-devel krb5-server krb5-workstation libtool \
    make openssl-devel patch pkgconfig rsync unzip vim-common which hostname memkind gem graphviz \
    ruby-devel zlib-devel openeuler-lsb && \
    ln -s /usr/bin/python3 /usr/bin/python

RUN curl -fSL --output kudu.tar.gz https://github.com/apache/kudu/archive/refs/tags/${VERSION}.tar.gz && \
    mkdir -p /kudu && tar -zvxf kudu.tar.gz -C /kudu --strip-components=1 && \
    rm -f kudu.tar.gz && yum clean all

RUN cd /kudu && \
    build-support/enable_devtoolset.sh && \
    thirdparty/build-if-necessary.sh 
    
RUN mkdir -p /kudu/build/release && cd /kudu/build/release && \
    ../../build-support/enable_devtoolset.sh && \
    ../../thirdparty/installed/common/bin/cmake \
        -DNO_TESTS=1 \
        -DCMAKE_BUILD_TYPE=release ../.. && \
    make -j"$(nproc)" && \
    make DESTDIR=/opt/kudu install && \
    ln -s /kudu/build/release/bin/kudu /usr/bin/kudu


FROM ${BASE}

ARG BUILD_DIR="/kudu"
ARG INSTALL_DIR="/opt/kudu"
ARG DATA_DIR="/var/lib/kudu"

COPY --chown=kudu:kudu entrypoint.sh /
RUN yum install -y shadow-utils && \
    groupadd -g 1000 kudu || groupmod -n kudu $(getent group 1000 | cut -d: -f1) && \
    useradd --shell /bin/bash -u 1000 -g kudu -m kudu && \
    mkdir -p ${INSTALL_DIR} && chown -R kudu:kudu ${INSTALL_DIR} && \
    mkdir -p ${DATA_DIR} && chown -R kudu:kudu ${DATA_DIR} && \
    chmod +x /entrypoint.sh

WORKDIR $INSTALL_DIR/bin
COPY --chown=kudu:kudu --from=build ${BUILD_DIR}/build/latest/bin/kudu ./
ENV PATH=$INSTALL_DIR/bin/:$PATH

WORKDIR $INSTALL_DIR
COPY --chown=kudu:kudu --from=build ${BUILD_DIR}/www ./www

USER kudu


ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]