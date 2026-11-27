ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG TARGETARCH
ARG VERSION=26.10.0.1
ARG GOSU_VERSION=1.17

RUN yum update -y && \
    yum install -y git wget g++ make ncurses-devel cmake openssl openssl-devel libtirpc-devel rpcgen bison m4 libcurl-devel systemd-devel && \
    mkdir -p /docker-entrypoint-initdb.d && \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}.asc" && \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}" && \
    wget -O mysql.tar.gz https://github.com/mysql/mysql-server/archive/refs/tags/mysql-${VERSION}.tar.gz && \
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
        -DDOWNLOAD_BOOST=1 \
        -DWITH_BOOST=/tmp/boost && \
    MAKE_JOBS="$(nproc)"; if [ "${TARGETARCH}" = "arm64" ]; then MAKE_JOBS=4; fi && \
    make -j "${MAKE_JOBS}" && make install && \
    rm -f mysql.tar.gz && \
    rm -rf /mysql && \
    yum -y remove wget g++ make && \
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
