ARG BASE=openeuler/openeuler:22.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=9.1.0
ARG GOSU_VERSION=1.17

RUN yum update -y && \
    mkdir -p /docker-entrypoint-initdb.d && \
    curl -fSL --output /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}.asc" && \
    curl -fSL --output /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}" && \
    curl -fSL --output mysql.tar.gz https://github.com/mysql/mysql-server/archive/refs/tags/mysql-${VERSION}.tar.gz && \
    mkdir -p /mysql && tar -xvf mysql.tar.gz -C /mysql --strip-components=1 && \
    mkdir -p /mysql/build && cd /mysql/build && \
    cmake /mysql \
        -DDEFAULT_CHARSET=utf8mb4 \
        -DDEFAULT_COLLATION=utf8mb4_unicode_ci \
        -DENABLED_LOCAL_INFILE=ON \
        -DWITH_SSL=system \
        -DCMAKE_INSTALL_PREFIX=/usr/local/mysql/server \
        -DMYSQL_DATADIR=/usr/local/mysql/data \
        -DMYSQL_TCP_PORT=3306 \
        -DDOWNLOAD_BOOST=0 && \
    make -j "$(nproc)" && make install && \
    rm -f mysql.tar.gz && \
    rm -rf /mysql && \
    yum -y remove g++ make && \
    yum clean all


ENV PATH=$PATH:/usr/local/mysql/server/bin
COPY config/ /etc/mysql/
COPY entrypoint.sh /usr/local/bin/

RUN groupadd -r mysql && \
    useradd -r -g mysql mysql && \
    mkdir -p /usr/local/mysql/data && \
    chown mysql:mysql /usr/local/mysql/data && \
    chmod 755 /usr/local/mysql/data && \
    chmod 755 /usr/local/bin/entrypoint.sh && \
    chmod 755 /usr/local/bin/gosu && \
    ln -s /usr/local/bin/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3306 33060
CMD ["mysqld"]
