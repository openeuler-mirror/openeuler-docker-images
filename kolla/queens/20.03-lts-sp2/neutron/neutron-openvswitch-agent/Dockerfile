FROM openeuler/openeuler-binary-neutron-base:queens-20.03-lts-sp2

RUN yum -y install openstack-neutron-openvswitch-agent openvswitch && yum clean all && rm -rf /var/cache/yum

USER neutron
