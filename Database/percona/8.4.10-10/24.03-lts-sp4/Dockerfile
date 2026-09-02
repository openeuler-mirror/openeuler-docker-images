ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=8.4.10-10
ARG GOSU_VERSION=1.17

RUN yum update -y --disablerepo=update --disablerepo=update-source && \
    yum install -y --disablerepo=update --disablerepo=update-source git wget g++ make ncurses-devel cmake openssl openssl-devel libtirpc-devel rpcgen bison m4 libcurl-devel && \
    mkdir -p /docker-entrypoint-initdb.d && \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}.asc" && \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}" && \
    wget -O percona.tar.gz https://github.com/percona/percona-server/archive/refs/tags/Percona-Server-${VERSION}.tar.gz && \
    mkdir -p /percona && tar -xvf percona.tar.gz -C /percona --strip-components=1 && \
    mkdir -p /percona/build && cd /percona/build && \
    cmake /percona \
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
    rm -f percona.tar.gz && \
    rm -rf /percona && \
    yum -y remove wget g++ make && \
    yum clean all


ENV PATH=$PATH:/usr/local/percona/server/bin
COPY config/ /etc/mysql/
COPY entrypoint.sh /usr/local/bin/

RUN groupadd -r mysql && \
    useradd -r -g mysql mysql && \
    mkdir -p /usr/local/percona/data && \
    chown mysql:mysql /usr/local/percona/data && \
    chmod 755 /usr/local/percona/data && \
    chmod 755 /usr/local/bin/entrypoint.sh && \
    chmod 755 /usr/local/bin/gosu && \
    ln -s /usr/local/bin/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3306 33060
CMD ["mysqld"]