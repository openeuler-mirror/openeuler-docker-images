ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG VERSION=2.91

RUN dnf update -y \
    && dnf install -y wget gcc make libidn-devel nettle-devel ncurses-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN wget https://thekelleys.org.uk/dnsmasq/dnsmasq-${VERSION}.tar.gz \
    && tar -xf dnsmasq-${VERSION}.tar.gz \
    && rm -f dnsmasq-${VERSION}.tar.gz \
    && cd dnsmasq-${VERSION} \
    && make -j$(nproc) \
    && make install

CMD ["/usr/local/sbin/dnsmasq", "--help"]