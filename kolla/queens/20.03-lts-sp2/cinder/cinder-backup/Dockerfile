FROM openeuler/openeuler-binary-cinder-base:queens-20.03-lts-sp2

RUN yum -y install nfs-utils && yum clean all && rm -rf /var/cache/yum

USER cinder
