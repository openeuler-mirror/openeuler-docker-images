FROM openeuler/openeuler-binary-glance-base:queens-20.03-lts-sp2

RUN yum -y install qemu-img && yum clean all && rm -rf /var/cache/yum

COPY extend_start.sh /usr/local/bin/kolla_glance_extend_start
RUN chmod 755 /usr/local/bin/kolla_glance_extend_start

USER glance
