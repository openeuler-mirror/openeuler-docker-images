ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG VERSION=2.4.58
ENV HTTPD_PREFIX /usr/local/apache2
WORKDIR ${HTTPD_PREFIX}

RUN yum install -y autoconf make gcc apr apr-devel apr-util-devel pcre-devel && \
    curl -fSL --output httpd.tar.gz https://archive.apache.org/dist/httpd/httpd-${VERSION}.tar.gz && \
    mkdir -p /src/httpd && tar -zvxf httpd.tar.gz -C /src/httpd --strip-components=1 && \
	rm -f httpd.tar.gz && yum clean all

RUN cd /src/httpd && \
    ./configure --prefix=/usr/local/apache2 && \
	make -j "$(nproc)" && \
	make install && \
    rm -rf /src/httpd

RUN groupadd -r www-data && useradd -r --create-home -g www-data www-data && \
    mkdir -p /var/www/html && \
    mv -f $HTTPD_PREFIX/htdocs/index.html /var/www/html/ && \
    sed -ri \
		-e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
		-e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
		-e 's!^(\s*TransferLog)\s+\S+!\1 /proc/self/fd/1!g' \
		-e 's!^(\s*User)\s+daemon\s*$!\1 www-data!g' \
		-e 's!^(\s*Group)\s+daemon\s*$!\1 www-data!g' \
		"$HTTPD_PREFIX/conf/httpd.conf" \
		"$HTTPD_PREFIX/conf/extra/httpd-ssl.conf" && \
    sed -ri -e 's!^(\s*DocumentRoot)\s+\S+!\1 "/var/www/html"!g' \
		"$HTTPD_PREFIX/conf/httpd.conf" && \
    sed -i '/^DocumentRoot/a\
<Directory "/var/www/html"> \n \
    Options Indexes FollowSymLinks \n \
    AllowOverride none \n \
    Require all granted \n \
</Directory>' "$HTTPD_PREFIX/conf/httpd.conf" && \
    ln -s $HTTPD_PREFIX/bin/httpd /usr/bin/httpd

STOPSIGNAL SIGWINCH
COPY httpd-foreground /usr/local/bin
EXPOSE 80
CMD ["httpd-foreground"]