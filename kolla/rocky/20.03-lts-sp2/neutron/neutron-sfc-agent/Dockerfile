FROM openeuler/openeuler-binary-neutron-base:rocky-20.03-lts-sp2

COPY extend_start.sh /usr/local/bin/kolla_neutron_extend_start
RUN chmod 755 /usr/local/bin/kolla_neutron_extend_start

USER neutron
