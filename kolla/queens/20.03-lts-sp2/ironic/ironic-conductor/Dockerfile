FROM openeuler/openeuler-binary-ironic-base:queens-20.03-lts-sp2

RUN yum -y install ansible dosfstools e2fsprogs gdisk ipmitool openssh-clients openstack-ironic-conductor parted psmisc python2-pysnmp python2-dracclient python2-ironic-inspector-client python2-proliantutils python2-scciclient python2-sushy systemd-python util-linux xfsprogs qemu && yum clean all && rm -rf /var/cache/yum

COPY extend_start.sh /usr/local/bin/kolla_ironic_extend_start
COPY iscsi_tcp_sudoers /etc/sudoers.d/kolla_iscsi_tcp_sudoers
RUN chmod 755 /usr/local/bin/kolla_ironic_extend_start \
    && chmod 440 /etc/sudoers.d/kolla_iscsi_tcp_sudoers

USER ironic
