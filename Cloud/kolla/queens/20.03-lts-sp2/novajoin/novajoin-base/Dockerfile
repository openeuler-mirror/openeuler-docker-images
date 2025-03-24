FROM openeuler/openeuler-binary-openstack-base:queens-20.03-lts-sp2

RUN usermod --append --home /var/lib/novajoin --groups kolla novajoin \
    && mkdir -p /var/lib/novajoin \
    && chown -R 42470:42470 /var/lib/novajoin

COPY extend_start.sh /usr/local/bin/kolla_extend_start
RUN chmod 750 /etc/sudoers.d \
    && touch /usr/local/bin/kolla_novajoin_extend_start \
    && chmod 755 /usr/local/bin/kolla_extend_start /usr/local/bin/kolla_novajoin_extend_start

