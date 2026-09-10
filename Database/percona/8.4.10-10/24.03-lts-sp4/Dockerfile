ARG BASE=openeuler/openeuler:24.03-lts-sp4

FROM ${BASE} AS builder

ARG VERSION=8.4.10-10

RUN yum update -y --disablerepo=update --disablerepo=update-source && \
    yum install -y --disablerepo=update --disablerepo=update-source git wget g++ make ncurses-devel cmake openssl openssl-devel zlib-devel libaio-devel numactl-devel libudev-devel libtirpc-devel rpcgen bison m4 libcurl-devel openldap-devel cyrus-sasl-devel krb5-devel && \
    wget -O percona.tar.gz https://github.com/percona/percona-server/archive/refs/tags/Percona-Server-${VERSION}.tar.gz && \
    mkdir -p /percona && tar -xvf percona.tar.gz -C /percona --strip-components=1 && \
    wget -O /tmp/coredumper.tar.gz https://github.com/Percona-Lab/coredumper/archive/8f2623b6d34bfc4e691bdf67b4a0d37c77513ac7.tar.gz && \
    mkdir -p /percona/extra/coredumper && tar -xvf /tmp/coredumper.tar.gz -C /percona/extra/coredumper --strip-components=1 && \
    wget -O /tmp/libkmip.tar.gz https://github.com/Percona-Lab/libkmip/archive/82988b2de6a0687791a3ae549fc2bd5cbeb457ab.tar.gz && \
    mkdir -p /percona/extra/libkmip && tar -xvf /tmp/libkmip.tar.gz -C /percona/extra/libkmip --strip-components=1 && \
    wget -O /tmp/rocksdb.tar.gz https://github.com/percona/rocksdb/archive/d0e615524b52e98b1b8862e13aaad3c04a5d252e.tar.gz && \
    mkdir -p /percona/storage/rocksdb/rocksdb && tar -xvf /tmp/rocksdb.tar.gz -C /percona/storage/rocksdb/rocksdb --strip-components=1 && \
    rm -f /tmp/coredumper.tar.gz /tmp/libkmip.tar.gz /tmp/rocksdb.tar.gz && \
    mkdir -p /percona/build && cd /percona/build && \
    cmake /percona \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DBUILD_CONFIG=mysql_release \
        -DFEATURE_SET=community \
        -DDEFAULT_CHARSET=utf8mb4 \
        -DDEFAULT_COLLATION=utf8mb4_unicode_ci \
        -DENABLED_LOCAL_INFILE=ON \
        -DWITH_SSL=system \
        -DCMAKE_INSTALL_PREFIX=/usr/local/percona/server \
        -DMYSQL_DATADIR=/usr/local/percona/data \
        -DMYSQL_TCP_PORT=3306 \
        -DDOWNLOAD_BOOST=1 \
        -DWITH_BOOST=/tmp/boost && \
    make -j "$(nproc)" && make install && \
    find /usr/local/percona/server -type f \( -name '*.so*' -o -perm -111 \) -exec strip --strip-unneeded {} + 2>/dev/null || true && \
    cd / && \
    rm -rf /percona /percona.tar.gz

FROM ${BASE}

ARG TARGETARCH
ARG GOSU_VERSION=1.17

ENV PATH=$PATH:/usr/local/percona/server/bin

RUN yum update -y --disablerepo=update --disablerepo=update-source && \
    yum install -y --disablerepo=update --disablerepo=update-source wget libaio numactl-libs shadow-utils findutils && \
    mkdir -p /docker-entrypoint-initdb.d && \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}" && \
    chmod 755 /usr/local/bin/gosu && \
    yum -y remove wget && \
    yum clean all

COPY --from=builder /usr/local/percona/server /usr/local/percona/server
COPY config/ /etc/mysql/
COPY entrypoint.sh /usr/local/bin/

RUN groupadd -r mysql && \
    useradd -r -g mysql mysql && \
    mkdir -p /usr/local/percona/data && \
    chown mysql:mysql /usr/local/percona/data && \
    chmod 755 /usr/local/percona/data && \
    chmod 755 /usr/local/bin/entrypoint.sh && \
    ln -s /usr/local/bin/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3306 33060
CMD ["mysqld"]
