FROM openeuler/openeuler-binary-glance-base:rocky-20.03-lts-sp2

COPY extend_start.sh /usr/local/bin/kolla_glance_extend_start
RUN chmod 755 /usr/local/bin/kolla_glance_extend_start

USER glance
