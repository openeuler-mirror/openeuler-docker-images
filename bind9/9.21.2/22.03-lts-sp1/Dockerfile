ARG BASE=openeuler/openeuler:22.03-lts-sp1
FROM ${BASE}

ARG VERSION=9.21.2

RUN yum -y update && yum -y install make gcc xz libcap-devel libuv-devel libnghttp2-devel openssl-devel perl && yum clean all
RUN curl -fSL --output bind9.tar.xz https://downloads.isc.org/isc/bind9/${VERSION}/bind-${VERSION}.tar.xz && \
    mkdir -p /bind9 && tar -xvf bind9.tar.xz -C /bind9 --strip-components=1 && \
    rm -rf bind9.tar.xz && cd /bind9 && \
    ./configure \
        --enable-syscalls \
        --prefix=/usr/local/bind9 \
        --enable-threads \
        --with-openssl=yes \
        --enable-openssl-version-check \
        --enable-ipv6 \
        --disable-linux-caps && \
    make -j "$(nproc)" && make install

ENV PATH=/usr/local/bind9/bin:/usr/local/bind9/sbin:$PATH
RUN mkdir /usr/local/bind9/dev && \
    mknod -m 666 /usr/local/bind9/dev/null c 1 3 && \
    mknod -m 666 /usr/local/bind9/dev/random c 1 8 && \
    mkdir -p /usr/local/bind9/data && \
    mkdir -p /usr/local/bind9/var/log

COPY named /etc/sysconfig/named
COPY named.conf /usr/local/bind9/etc/named.conf
RUN /usr/local/bind9/sbin/rndc-confgen -a && \
    ln -s /usr/local/bind9/etc/rndc.key /etc/rndc.key && \
    ln -s /usr/local/bind9/etc/named.conf /etc/named.conf

EXPOSE 53 953

CMD ["named", "-g", "-t", "/usr/local/bind9", "-c", "/etc/named.conf"]