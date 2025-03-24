FROM openeuler/openeuler-binary-base:rocky-20.03-lts-sp2

RUN yum -y install hostname keepalived && yum clean all && rm -rf /var/cache/yum

COPY check_alive.sh /

COPY extend_start.sh /usr/local/bin/kolla_extend_start
RUN chmod 755 /usr/local/bin/kolla_extend_start /check_alive.sh

