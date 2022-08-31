FROM openeuler/openeuler:22.03-lts
MAINTAINER heguofeng <heguofeng@openeuler.sh>
RUN yum -y update && \
    yum -y install sudo util-linux lsof && \
    yum -y install opengauss && \
    su - opengauss -c "gs_ctl stop -D /var/lib/opengauss/data -mf " && \
    rm -rf /var/lib/opengauss/data && \
    sed -i 's/7654/5432/g' /var/lib/opengauss/.bash_profile && \
    sed -i "s/listen_addresses = '127.0.0.1'/listen_addresses = '0.0.0.0'/g"  /usr/local/opengauss/share/postgresql/postgresql.conf.sample && \
    sed -i 's/port = 7654/port = 5432/g'  /usr/local/opengauss/share/postgresql/postgresql.conf.sample && \
    mkdir /docker-entrypoint-initdb.d && \
    chown opengauss:opengauss /docker-entrypoint-initdb.d && \
    yum clean all

COPY gosu-amd64 /usr/local/bin/gosu_amd64
COPY gosu-arm64 /usr/local/bin/gosu_arm64

ENV GOSU_VERSION 1.12
RUN set -eux; \
     chmod +x /usr/local/bin/gosu_amd64 &&  \
     chmod +x /usr/local/bin/gosu_arm64

ENV PGDATA /var/lib/opengauss/data
COPY entrypoint.sh /var/lib/opengauss/
RUN chmod 755 /var/lib/opengauss/entrypoint.sh

ENTRYPOINT ["/var/lib/opengauss/entrypoint.sh"]
EXPOSE 5432
CMD [ "gaussdb" ]
