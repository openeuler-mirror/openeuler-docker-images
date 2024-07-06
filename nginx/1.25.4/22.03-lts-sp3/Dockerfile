ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.25.4

RUN yum -y install gcc openssl-devel make libxml2-devel libxslt-devel gd-devel perl\
    GeoIP-devel gperftools-devel && \
    yum clean all && \
    curl -o /tmp/nginx.tar.gz https://nginx.org/download/nginx-${VERSION}.tar.gz && \
    tar -zxvf /tmp/nginx.tar.gz -C /tmp && \
    cd /tmp/nginx-${VERSION} && \
    mkdir -p /var/tmp/nginx/ && \
    ./configure \
    --prefix=/usr/local/nginx --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/local/nginx/modules --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log \
    --http-client-body-temp-path=/var/tmp/nginx/client \
    --http-fastcgi-temp-path=/var/tmp/nginx/fcgi \
    --http-proxy-temp-path=/var/tmp/nginx/proxy \
    --http-scgi-temp-path=/var/tmp/nginx/scgi \
    --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --with-file-aio --with-ipv6 --with-http_ssl_module --with-http_v2_module \
    --with-http_realip_module --with-http_addition_module \
    --with-http_xslt_module=dynamic --with-http_image_filter_module=dynamic \
    --with-http_geoip_module=dynamic --with-http_sub_module \
    --with-http_dav_module --with-http_flv_module --with-http_mp4_module \
    --with-http_gunzip_module --with-http_gzip_static_module \
    --with-http_random_index_module --with-http_secure_link_module \
    --with-http_degradation_module --with-http_slice_module \
    --with-http_perl_module=dynamic --with-http_auth_request_module \
    --with-mail=dynamic --with-mail_ssl_module --with-openssl-opt=yes \
    --with-pcre --with-pcre-jit --with-stream=dynamic \
    --with-stream_ssl_module --with-google_perftools_module --with-debug && \
    make && make install && \
    rm -rf /tmp/nginx.tar.gz /tmp/nginx-${VERSION}

ENV PATH /usr/local/nginx:$PATH
WORKDIR /usr/local/nginx/html


EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]