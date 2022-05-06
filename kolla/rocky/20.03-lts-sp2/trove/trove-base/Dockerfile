FROM openeuler/openeuler-binary-openstack-base:rocky-20.03-lts-sp2

RUN usermod --append --home /var/lib/trove --groups kolla trove \
    && mkdir -p /var/lib/trove \
    && chown -R 42449:42449 /var/lib/trove

RUN yum -y install openstack-trove-common && yum clean all && rm -rf /var/cache/yum

COPY extend_start.sh /usr/local/bin/kolla_extend_start

RUN touch /usr/local/bin/kolla_trove_extend_start \
    && chmod 755 /usr/local/bin/kolla_extend_start /usr/local/bin/kolla_trove_extend_start

