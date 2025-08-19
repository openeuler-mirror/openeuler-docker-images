ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=7.1
ARG SQUID_PREFIX=/usr/local/squid
RUN yum -y update && yum -y install wget gcc g++ make perl openssl shadow-utils && yum clean all && \
    wget -O squid.tar.gz https://github.com/squid-cache/squid/releases/download/SQUID_${VERSION//./_}/squid-${VERSION}.tar.gz
RUN mkdir /squid && tar -xvf squid.tar.gz -C /squid --strip-components 1 && \
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
    sed -i '$a\max_filedescriptors 65536' $SQUID_PREFIX/etc/squid.conf && \
    sed -i '$a\cache_dir ufs /usr/local/squid/var/cache/squid 100 16 256' $SQUID_PREFIX/etc/squid.conf && \
    chmod 755 /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
EXPOSE 3128
