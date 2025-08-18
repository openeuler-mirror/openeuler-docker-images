ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=11.2

RUN dnf install -y wget make gcc-c++ rpcgen \
    autoconf automake libtool liburing liburing-devel \
    gperftools gperftools-devel \
    flex bison openssl-devel libuuid libuuid-devel \
    libacl libacl-devel zlib zlib-devel \
    libxml2 libxml2-devel libtirpc libtirpc-devel \
    userspace-rcu userspace-rcu-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://github.com/gluster/glusterfs/archive/refs/tags/v${VERSION}.tar.gz \
    && tar -zxvf v${VERSION}.tar.gz \
    && rm -f v${VERSION}.tar.gz

WORKDIR /opt/glusterfs-${VERSION}

RUN ./autogen.sh \
    && ./configure \
    && make -j \
    && make install

CMD ["gluster", "--help"]