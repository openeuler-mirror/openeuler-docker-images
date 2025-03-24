FROM openeuler/openeuler-binary-neutron-base:rocky-20.03-lts-sp2

RUN yum -y install ebtables openstack-neutron-linuxbridge && yum clean all && rm -rf /var/cache/yum

USER neutron
