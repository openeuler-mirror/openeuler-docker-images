FROM openeuler/openeuler-binary-openstack-base:rocky-20.03-lts-sp2

RUN usermod --append --home /var/lib/horizon --groups kolla horizon \
    && mkdir -p /var/lib/horizon \
    && chown -R 42420:42420 /var/lib/horizon

RUN yum -y install gettext httpd mod_ssl mod_wsgi openstack-dashboard && yum clean all && rm -rf /var/cache/yum

RUN sed -i -r 's,^(Listen 80),#\1,' /etc/httpd/conf/httpd.conf \
    && sed -i -r 's,^(Listen 443),#\1,' /etc/httpd/conf.d/ssl.conf \
    && ln -s /usr/share/openstack-dashboard/openstack_dashboard /usr/lib/python2.7/site-packages/openstack_dashboard \
    && ln -s /usr/share/openstack-dashboard/static /usr/lib/python2.7/site-packages/static \
    && chown -R horizon: /etc/openstack-dashboard /usr/share/openstack-dashboard \
    && chown -R apache: /usr/share/openstack-dashboard/static \
    && sed -i "s|WEBROOT = '/dashboard/'|WEBROOT = '/'|" /etc/openstack-dashboard/local_settings \
    && cp /usr/share/openstack-dashboard/manage.py /usr/bin/manage.py \
    && rm -f /usr/share/openstack-dashboard/openstack_dashboard/local/enabled/?[^_]*.py* \
    && rm -f /usr/lib/python2.7/site-packages/openstack_dashboard/local/enabled/?[^_]*.py* \
    && for locale in /usr/lib/python2.7/site-packages/*/locale; do \
           (cd ${locale%/*} && /usr/bin/python /usr/bin/manage.py compilemessages) \
       done

COPY extend_start.sh /usr/local/bin/kolla_extend_start
RUN chmod 755 /usr/local/bin/kolla_extend_start

