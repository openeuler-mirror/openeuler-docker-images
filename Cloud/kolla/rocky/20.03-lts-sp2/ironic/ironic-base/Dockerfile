FROM openeuler/openeuler-binary-openstack-base:rocky-20.03-lts-sp2

RUN usermod --append --home /var/lib/ironic --groups kolla ironic \
    && mkdir -p /var/lib/ironic \
    && chown -R 42422:42422 /var/lib/ironic

RUN yum -y install openstack-ironic-common && yum clean all && rm -rf /var/cache/yum

COPY extend_start.sh /usr/local/bin/kolla_extend_start

RUN touch /usr/local/bin/kolla_ironic_extend_start \
    && chmod 755 /usr/local/bin/kolla_extend_start /usr/local/bin/kolla_ironic_extend_start \
    && chown -R ironic: /etc/ironic
