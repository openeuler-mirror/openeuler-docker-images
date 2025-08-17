ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=3.5.1

RUN dnf update -y \
    && dnf install -y wget git gcc make autoconf automake libtool \
    openssl-devel libcap-ng-devel unbound-devel nmap-ncat net-tools \
    graphviz clang python3-flake8 python3-pip \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://mirrors.tuna.tsinghua.edu.cn/gnu/groff/groff-1.23.0.tar.gz \
    && tar -xf groff-1.23.0.tar.gz \
    && rm -f groff-1.23.0.tar.gz \
    && cp groff-1.23.0/tmac/en.tmac /usr/share/groff/1.23.0/tmac/ \
    && rm -rf groff-1.23.0

RUN wget https://github.com/openvswitch/ovs/archive/refs/tags/v${VERSION}.tar.gz \
    && tar -zxvf v${VERSION}.tar.gz \
    && rm -f v${VERSION}.tar.gz

WORKDIR /opt/ovs-${VERSION}

RUN ./boot.sh \
    && ./configure \
    && make -j \
    && make install

CMD ["ovs-vsctl", "--help"]