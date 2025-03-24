FROM openeuler/openeuler-binary-nova-base:rocky-20.03-lts-sp2

RUN yum -y install genisoimage nvme-cli openstack-nova-compute && yum clean all && rm -rf /var/cache/yum

USER nova
