ARG BASE=openeuler/openeuler:22.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=17_0
ARG GOSU_VERSION=1.17

RUN yum -y install wget make gcc icu libicu-devel readline-devel zlib-devel findutils shadow-utils \
    perl bison m4 flex && \
    yum clean all && \
    groupadd --system --gid 1000 postgres && \
    useradd --system --gid postgres --uid 1000 postgres && \
    wget -O /usr/local/bin/gosu_${TARGETARCH} https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH} && \
    chmod +x /usr/local/bin/gosu_${TARGETARCH} && \
    wget -O /tmp/postgres.tar.gz https://github.com/postgres/postgres/archive/refs/tags/REL_${VERSION}.tar.gz && \
    tar -zxvf /tmp/postgres.tar.gz -C /tmp && \
    cd /tmp/postgres-REL_${VERSION} && \
    ./configure && \
    make -j "$(nproc)" && make install && \
    mkdir /docker-entrypoint-initdb.d && \
    chown postgres:postgres /docker-entrypoint-initdb.d && \
    rm -rf /tmp/postgres.tar.gz /tmp/postgres-REL_${VERSION}

VOLUME /var/lib/pgsql/data

ENV PGDATA /var/lib/pgsql/data
COPY entrypoint.sh /var/lib/pgsql/
RUN chmod 755 /var/lib/pgsql/entrypoint.sh

ENV PATH ${PATH}:/usr/local/pgsql/bin

ENTRYPOINT ["/var/lib/pgsql/entrypoint.sh"]
EXPOSE 5432
CMD [ "postgres" ]