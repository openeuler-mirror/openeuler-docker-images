FROM openeuler/openeuler-binary-trove-base:rocky-20.03-lts-sp2

RUN yum -y install openstack-trove-guestagent && yum clean all && rm -rf /var/cache/yum

USER trove
