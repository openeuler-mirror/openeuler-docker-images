FROM openeuler/openeuler-binary-trove-base:queens-20.03-lts-sp2

RUN yum -y install openstack-trove-conductor && yum clean all && rm -rf /var/cache/yum

USER trove
