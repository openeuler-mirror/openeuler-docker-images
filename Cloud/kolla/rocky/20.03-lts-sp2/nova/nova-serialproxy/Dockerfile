FROM openeuler/openeuler-binary-nova-base:rocky-20.03-lts-sp2

RUN yum -y install openstack-nova-serialproxy && yum clean all && rm -rf /var/cache/yum

USER nova
