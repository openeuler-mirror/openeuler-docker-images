FROM openeuler/openeuler-binary-nova-base:queens-20.03-lts-sp2

RUN yum -y install ceph-common device-mapper-multipath e2fsprogs genisoimage iscsi-initiator-utils nfs-utils openstack-nova-compute openvswitch parted python2-libguestfs python2-oslo-vmware python2-rtslib-fb sysfsutils xfsprogs && yum clean all && rm -rf /var/cache/yum

COPY extend_start.sh /usr/local/bin/kolla_nova_extend_start
RUN chmod 755 /usr/local/bin/kolla_nova_extend_start \
    && rm -f /etc/machine-id

USER nova

