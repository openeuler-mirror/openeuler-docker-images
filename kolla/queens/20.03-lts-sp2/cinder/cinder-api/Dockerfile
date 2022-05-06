FROM openeuler/openeuler-binary-cinder-base:queens-20.03-lts-sp2

RUN yum -y install httpd mod_ssl mod_wsgi python2-keystone && yum clean all && rm -rf /var/cache/yum
RUN mkdir -p /var/www/cgi-bin/cinder \
    && cp -a /usr/bin/cinder-wsgi /var/www/cgi-bin/cinder/cinder-wsgi \
    && sed -i -r 's,^(Listen 80),#\1,' /etc/httpd/conf/httpd.conf \
    && sed -i -r 's,^(Listen 443),#\1,' /etc/httpd/conf.d/ssl.conf

COPY extend_start.sh /usr/local/bin/kolla_cinder_extend_start
RUN chmod 755 /usr/local/bin/kolla_cinder_extend_start \
    && chown -R cinder: /var/www/cgi-bin/cinder \
    && chmod 755 /var/www/cgi-bin/cinder/cinder-wsgi

