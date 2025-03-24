FROM openeuler/openeuler-binary-keystone-base:queens-20.03-lts-sp2

COPY keystone_bootstrap.sh /usr/local/bin/kolla_keystone_bootstrap
COPY extend_start.sh /usr/local/bin/kolla_extend_start
RUN chmod 755 /usr/local/bin/kolla_extend_start /usr/local/bin/kolla_keystone_bootstrap

