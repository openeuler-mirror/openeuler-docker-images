FROM openeuler/openeuler-binary-base:queens-20.03-lts-sp2

RUN usermod --append --home /var/lib/haproxy --groups kolla haproxy \
    && mkdir -p /var/lib/haproxy \
    && chown -R 42454:42454 /var/lib/haproxy

RUN yum -y install haproxy && yum clean all && rm -rf /var/cache/yum

RUN mkdir -p /var/lib/kolla/haproxy \
    && chown -R haproxy: /var/lib /run

COPY ensure_latest_config.sh /usr/local/bin/kolla_ensure_haproxy_latest_config
RUN chmod 755 /usr/local/bin/kolla_ensure_haproxy_latest_config
