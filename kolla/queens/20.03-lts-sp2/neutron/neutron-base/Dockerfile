FROM openeuler/openeuler-binary-openstack-base:queens-20.03-lts-sp2

RUN usermod --append --home /var/lib/neutron --groups kolla neutron \
    && mkdir -p /var/lib/neutron \
    && chown -R 42435:42435 /var/lib/neutron

RUN yum -y install keepalived net-tools openstack-neutron openstack-neutron-ml2 openvswitch python2-openvswitch python2-oslo-vmware && yum clean all && rm -rf /var/cache/yum

COPY neutron_sudoers /etc/sudoers.d/kolla_neutron_sudoers
COPY extend_start.sh /usr/local/bin/kolla_extend_start

RUN chmod 750 /etc/sudoers.d \
    && chmod 440 /etc/sudoers.d/kolla_neutron_sudoers \
    && touch /usr/local/bin/kolla_neutron_extend_start \
    && chmod 755 /usr/local/bin/kolla_extend_start /usr/local/bin/kolla_neutron_extend_start

