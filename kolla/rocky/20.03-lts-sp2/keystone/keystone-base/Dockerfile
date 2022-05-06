FROM openeuler/openeuler-binary-openstack-base:rocky-20.03-lts-sp2

RUN usermod --append --home /var/lib/keystone --groups kolla keystone \
    && mkdir -p /var/lib/keystone \
    && chown -R 42425:42425 /var/lib/keystone

RUN yum -y install httpd mod_ssl mod_wsgi openstack-keystone python2-ldappool python2-keystoneclient && yum clean all && rm -rf /var/cache/yum
RUN mkdir -p /var/www/cgi-bin/keystone \
    && cp -a /usr/bin/keystone-wsgi-public /var/www/cgi-bin/keystone/main \
    && cp -a /usr/bin/keystone-wsgi-admin /var/www/cgi-bin/keystone/admin \
    && sed -i -r 's,^(Listen 80),#\1,' /etc/httpd/conf/httpd.conf \
    && sed -i -r 's,^(Listen 443),#\1,' /etc/httpd/conf.d/ssl.conf

RUN chown -R keystone: /var/www/cgi-bin/keystone \
    && chmod 755 /var/www/cgi-bin/keystone/*

