FROM openeuler/openeuler-binary-nova-base:queens-20.03-lts-sp2

RUN yum -y install genisoimage openstack-nova-compute && yum clean all && rm -rf /var/cache/yum

USER nova
