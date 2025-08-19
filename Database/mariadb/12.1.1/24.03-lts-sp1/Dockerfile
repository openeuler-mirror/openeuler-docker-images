ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=12.1.1

RUN yum install -y bison ncurses-devel openssl-devel g++ make gcc cmake && \
    yum clean all

RUN curl -fSL -o mariadb.tar.gz https://archive.mariadb.org//mariadb-${VERSION}/source/mariadb-${VERSION}.tar.gz && \
    mkdir -p /mariadb && \
    tar -zxf mariadb.tar.gz -C /mariadb --strip-components=1 && \
    rm -rf mariadb.tar.gz && \
    cd /mariadb && \
    cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mariadb \
        -DMYSQL_DATADIR=/data/mariadb/data \
        -DSYSCONFDIR=/etc -DWITHOUT_TOKUDB=1 \
        -DWITH_INNOBASE_STORAGE_ENGINE=1 \
        -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
        -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
        -DWITH_READLINE=1 \
        -DWITH_SSL=system \
        -DWITH_ZLIB=system \
        -DWITH_LOBWRAP=0 \
        -DMYSQL_UNIX_ADDR=/data/mariadb/run/mysql.sock \
        -DDEFAULT_CHARSET=utf8 \
        -DDEFAULT_COLLATION=utf8_general_ci && \
    make -j8 && make install && \
    rm -rf /mariadb

RUN yum install -y shadow-utils
RUN mkdir -p /data/mariadb/data && \
    mkdir -p /data/mariadb/run && \
    mkdir -p /data/mariadb/log && \
    groupadd -r mariadb && \
    useradd -r -g mariadb -s /bin/false mariadb && \
    chown -R mariadb:mariadb /data/mariadb && \
    /usr/local/mariadb/scripts/mariadb-install-db \
        --user=mariadb \
        --datadir=/data/mariadb/data \
        --basedir=/usr/local/mariadb

ENV PATH=/usr/local/mariadb/bin:$PATH
CMD ["mysqld", "--user", "mariadb"]
