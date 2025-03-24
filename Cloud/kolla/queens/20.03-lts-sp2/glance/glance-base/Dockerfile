FROM openeuler/openeuler-binary-openstack-base:queens-20.03-lts-sp2

RUN usermod --append --home /var/lib/glance --groups kolla glance \
    && mkdir -p /var/lib/glance \
    && chown -R 42415:42415 /var/lib/glance

RUN yum -y install openstack-glance python2-oslo-vmware python-rados python-rbd && yum clean all && rm -rf /var/cache/yum

COPY extend_start.sh /usr/local/bin/kolla_extend_start

RUN touch /usr/local/bin/kolla_glance_extend_start \
    && chmod 755 /usr/local/bin/kolla_extend_start /usr/local/bin/kolla_glance_extend_start

