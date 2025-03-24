FROM openeuler/openeuler-binary-base:rocky-20.03-lts-sp2

RUN usermod --append --home /var/lib/prometheus --groups kolla prometheus \
    && mkdir -p /var/lib/prometheus \
    && chown -R 42472:42472 /var/lib/prometheus

ENV prometheus_arch=arm64

COPY extend_start.sh /usr/local/bin/kolla_extend_start
RUN chmod 755 /usr/local/bin/kolla_extend_start
