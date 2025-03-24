FROM openeuler/openeuler-binary-base:rocky-20.03-lts-sp2

RUN usermod --append --home /var/lib/mysql --groups kolla mysql \
    && mkdir -p /var/lib/mysql \
    && chown -R 42434:42434 /var/lib/mysql

RUN yum -y install expect galera hostname mariadb-server-galera pv rsync tar mariadb mariadb-server MySQL-python python2-PyMySQL && yum clean all && rm -rf /var/cache/yum

COPY mariadb_sudoers /etc/sudoers.d/kolla_mariadb_sudoers
COPY extend_start.sh /usr/local/bin/kolla_extend_start
COPY security_reset.expect /usr/local/bin/kolla_security_reset
RUN chmod 755 /usr/local/bin/kolla_extend_start \
    && chmod 755 /usr/local/bin/kolla_security_reset \
    && chmod 750 /etc/sudoers.d \
    && chmod 440 /etc/sudoers.d/kolla_mariadb_sudoers \
    && rm -rf /var/lib/mysql/*

ENTRYPOINT ["dumb-init", "--"]
CMD ["kolla_start"]

USER mysql
