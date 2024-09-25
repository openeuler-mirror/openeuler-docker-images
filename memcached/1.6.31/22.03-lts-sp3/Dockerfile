ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.6.31

RUN groupadd --system --gid 11211 memcache && \
    useradd --system --gid memcache --uid 11211 memcache && \
    mkdir -p /memcache/rules && \
    mkdir -p /memcache/rules-temp && \
    mkdir -p /etc/memcache && \
    chown -R memcache:memcache /etc/memcache /memcache

RUN yum -y install gcc make libevent-devel && \
    yum clean all

RUN curl -o /tmp/memcached.tar.gz https://www.memcached.org/files/memcached-${VERSION}.tar.gz && \
    tar -zxvf /tmp/memcached.tar.gz -C /tmp && \
    cd /tmp/memcached-${VERSION} && \
    ./configure && \
    make && make install && \
    rm -rf /tmp/memcached.tar.gz /tmp/memcached-${VERSION}


COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

USER memcache
EXPOSE 11211

CMD ["memcached", "-u", "daemon"]
