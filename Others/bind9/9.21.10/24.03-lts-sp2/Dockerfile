ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}

ARG VERSION=9.21.10

RUN yum -y update && \
    yum -y install make gcc xz libcap-devel libuv-devel libnghttp2-devel openssl-devel perl userspace-rcu userspace-rcu-devel \
        meson krb5-devel protobuf-c-devel fstrm-devel json-c-devel libmaxminddb-devel libidn2-devel lmdb-devel shadow-utils && \
    yum clean all
RUN curl -fSL --output bind9.tar.xz https://downloads.isc.org/isc/bind9/${VERSION}/bind-${VERSION}.tar.xz && \
    mkdir -p /bind9 && tar -xvf bind9.tar.xz -C /bind9 --strip-components=1 && \
    rm -rf bind9.tar.xz && cd /bind9 && \
    meson setup \
        --prefix=/usr \
        --sysconfdir=/etc/bind \
        --localstatedir=/ \
        --default-library=shared \
        -Dgssapi=enabled \
        -Didn=enabled \
        -Dstats-json=enabled \
        -Dlmdb=enabled \
        -Dgeoip=enabled \
        -Ddnstap=enabled \
        build && \
    meson compile -j -1 -C build && \
    meson install -C build

RUN groupadd -r -g 53 bind && \
    useradd -r -u 53 -g bind -d /var/cache/bind -s /sbin/nologin bind && \
    mkdir -p /etc/bind && chown root:bind /etc/bind/ && chmod 755 /etc/bind

COPY named.conf /etc/bind
RUN chown root:bind /etc/bind/named.conf && chmod 644 /etc/bind/named.conf && \
    mkdir -p /var/cache/bind && chown bind:bind /var/cache/bind && chmod 755 /var/cache/bind && \
    mkdir -p /var/lib/bind && chown bind:bind /var/lib/bind && chmod 755 /var/lib/bind && \
    mkdir -p /var/log/bind && chown bind:bind /var/log/bind && chmod 755 /var/log/bind && \
    mkdir -p /run/named && chown bind:bind /run/named && chmod 755 /run/named

VOLUME ["/etc/bind", "/var/cache/bind", "/var/lib/bind", "/var/log"]

EXPOSE 53 953 853 443

ENTRYPOINT ["/usr/sbin/named", "-u", "bind"]
CMD ["-f", "-g", "-c", "/etc/bind/named.conf", "-L", "/var/log/bind/default.log"]