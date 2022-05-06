FROM openeuler/openeuler-binary-ironic-base:rocky-20.03-lts-sp2

RUN yum -y install httpd mod_ssl mod_wsgi openstack-ironic-api && yum clean all && rm -rf /var/cache/yum

RUN sed -i -r 's,^(Listen 80),#\1,' /etc/httpd/conf/httpd.conf \
    && sed -i -r 's,^(Listen 443),#\1,' /etc/httpd/conf.d/ssl.conf

COPY extend_start.sh /usr/local/bin/kolla_ironic_extend_start
RUN chmod 755 /usr/local/bin/kolla_ironic_extend_start

USER ironic
