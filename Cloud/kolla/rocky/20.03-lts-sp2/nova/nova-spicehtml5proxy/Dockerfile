FROM openeuler/openeuler-binary-nova-base:rocky-20.03-lts-sp2

RUN yum -y install numpy openstack-nova-spicehtml5proxy && yum clean all && rm -rf /var/cache/yum

USER nova
