ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG VERSION=6.8
ARG SQUID_PREFIX=/usr/local/squid
RUN yum -y update && yum -y install wget gcc g++ make perl openssl && yum clean all && \
    wget -O squid.tar.bz2 http://www.squid-cache.org/Versions/v${VERSION%%.*}/squid-${VERSION}.tar.bz2
RUN mkdir /squid && tar -jxvf squid.tar.bz2 -C /squid --strip-components 1 && \
    cd /squid && ./configure \
        --prefix=$SQUID_PREFIX \
        --enable-arp-acl \
        --enable-linux-netfilter \
        --enable-linux-tproxy \
        --enable-async-io=100 \
        --enable-poll \
        --enable-gnuregex && \
    make -j "$(nproc)" && make install && \
    rm -rf squid.tar.gz /squid && \
    ln -s $SQUID_PREFIX/sbin/* /usr/local/sbin/ && \
    useradd -M -s /sbin/nologin squid && \
    chown -R squid:squid $SQUID_PREFIX/var/

COPY entrypoint.sh /usr/local/bin/
RUN sed -i '$a\cache_effective_user squid' $SQUID_PREFIX/etc/squid.conf && \
    sed -i '$a\cache_effective_group squid' $SQUID_PREFIX/etc/squid.conf && \
    sed -i '$a\visible_hostname 192.168.0.101' $SQUID_PREFIX/etc/squid.conf && \
    sed -i '$a\cache_dir ufs /usr/local/squid/var/cache/squid 100 16 256' $SQUID_PREFIX/etc/squid.conf && \
    chmod 755 /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
EXPOSE 3128
