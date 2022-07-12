FROM openeuler/openeuler-binary-openstack-base:queens-20.03-lts-sp2

RUN usermod --append --home /var/lib/cinder --groups kolla cinder \
    && mkdir -p /var/lib/cinder \
    && chown -R 42407:42407 /var/lib/cinder

RUN yum -y install ceph-common lvm2 cryptsetup openstack-cinder python2-automaton python2-oslo-vmware && yum clean all && rm -rf /var/cache/yum

COPY cinder_sudoers /etc/sudoers.d/kolla_cinder_sudoers
COPY extend_start.sh /usr/local/bin/kolla_extend_start

RUN chmod 750 /etc/sudoers.d \
    && chmod 440 /etc/sudoers.d/kolla_cinder_sudoers \
    && touch /usr/local/bin/kolla_cinder_extend_start \
    && chmod 755 /usr/local/bin/kolla_extend_start /usr/local/bin/kolla_cinder_extend_start

