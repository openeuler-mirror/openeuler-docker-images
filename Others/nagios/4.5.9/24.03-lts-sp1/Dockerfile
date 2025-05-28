ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=4.5.9

RUN dnf update -y \
    && dnf install -y gcc-c++ make glibc-common perl httpd php wget gd gd-devel openssl-devel unzip \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN  wget https://github.com/NagiosEnterprises/nagioscore/archive/refs/tags/nagios-${VERSION}.tar.gz \
    && tar -zxvf nagios-${VERSION}.tar.gz \
    && rm -f nagios-${VERSION}.tar.gz

WORKDIR /opt/nagioscore-nagios-${VERSION}

RUN ./configure \
    && make all \
    && make install-groups-users \
    && usermod -a -G nagios apache \
    && make install

CMD ["/usr/local/nagios/bin/nagios", "--help"]