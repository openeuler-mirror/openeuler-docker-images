ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG VERSION=4.4.3

RUN dnf update -y \
    && dnf install -y wget gcc-c++ make libtool perl \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN wget https://ftp.isc.org/isc/dhcp/${VERSION}/dhcp-${VERSION}.tar.gz \
    && tar -xf dhcp-${VERSION}.tar.gz \
    && rm -f dhcp-${VERSION}.tar.gz \
    && cd dhcp-${VERSION} \
    && ./configure --prefix=/usr/local/dhcp \
    && make -j$(nproc) \
    && make install

RUN mkdir -p /var/db && touch /var/db/dhcpd.leases

CMD ["/usr/local/dhcp/sbin/dhcpd", "--help"]