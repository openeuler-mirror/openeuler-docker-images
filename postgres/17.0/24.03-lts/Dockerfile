FROM openeuler/openeuler:24.03-lts
MAINTAINER heguofeng <heguofeng@openeuler.sh>
RUN yum -y update && \
    yum -y install sudo util-linux lsof && \
    yum -y install postgresql-server postgresql && \
    mkdir /docker-entrypoint-initdb.d && \
    chown postgres:postgres /docker-entrypoint-initdb.d && \
    yum clean all

COPY gosu-amd64 /usr/local/bin/gosu_amd64
COPY gosu-arm64 /usr/local/bin/gosu_arm64

ENV GOSU_VERSION 1.12
RUN set -eux; \
     chmod +x /usr/local/bin/gosu_amd64 &&  \
     chmod +x /usr/local/bin/gosu_arm64

VOLUME /var/lib/pgsql/data

ENV PGDATA /var/lib/pgsql/data
COPY entrypoint.sh /var/lib/pgsql/
RUN chmod 755 /var/lib/pgsql/entrypoint.sh

ENTRYPOINT ["/var/lib/pgsql/entrypoint.sh"]
EXPOSE 5432
CMD [ "postgres" ]
