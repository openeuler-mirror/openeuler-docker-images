FROM openeuler/openeuler-binary-trove-base:queens-20.03-lts-sp2

RUN yum -y install openstack-trove-api && yum clean all && rm -rf /var/cache/yum

COPY extend_start.sh /usr/local/bin/kolla_trove_extend_start
RUN chmod 755 /usr/local/bin/kolla_trove_extend_start

USER trove
