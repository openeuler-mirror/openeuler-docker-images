ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.25.4

RUN yum -y install gcc openssl-devel make && \
    yum clean all

RUN curl -o /tmp/nginx.tar.gz https://nginx.org/download/nginx-${VERSION}.tar.gz && \
    tar -zxvf /tmp/nginx.tar.gz -C /tmp && \
    cd /tmp/nginx-${VERSION} && \
    ./configure \
    --sbin-path=/usr/local/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --pid-path=/usr/local/nginx/nginx.pid \
    --with-http_ssl_module && \
    make && make install && \
    rm -rf /tmp/nginx.tar.gz /tmp/nginx-${VERSION}

ENV PATH /usr/local/nginx:$PATH
WORKDIR /usr/local/nginx/html


EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]