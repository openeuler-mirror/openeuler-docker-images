FROM openeuler/openeuler-binary-openstack-base:rocky-20.03-lts-sp2

RUN usermod --append --home /var/lib/ironic-inspector --groups kolla ironic-inspector \
    && mkdir -p /var/lib/ironic-inspector \
    && chown -R 42461:42461 /var/lib/ironic-inspector

RUN yum -y install openstack-ironic-inspector && yum clean all && rm -rf /var/cache/yum

COPY extend_start.sh /usr/local/bin/kolla_extend_start

RUN chmod 755 /usr/local/bin/kolla_extend_start \
    && chown -R ironic-inspector: /etc/ironic-inspector

USER ironic-inspector
