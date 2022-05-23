FROM openeuler/openeuler-binary-neutron-base:queens-20.03-lts-sp2

RUN yum -y install libreswan && yum clean all && rm -rf /var/cache/yum

USER neutron
