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
    && rm -f nagios-${VERSION}.tar.gz \
    && mv nagioscore-nagios-* nagios

WORKDIR /opt/nagios

RUN ./configure \
    && make all \
    && make install-groups-users \
    && usermod -a -G nagios apache \
    && make install

RUN mkdir -p /usr/local/nagios/var/rw \
    && mkdir -p /opt/nagios/t/var/spool/checkresults \
    && chown -R nagios:nagios /usr/local/nagios/var \
    && chmod 775 /usr/local/nagios/var/rw \
    && chmod -R 777 /opt/nagios/t/var

RUN sed -i 's|^command_file=.*|command_file=/usr/local/nagios/var/rw/nagios.cmd|' /opt/nagios/t/etc/nagios.cfg \
    && echo "query_socket=/usr/local/nagios/var/rw/nagios.qh" >> /opt/nagios/t/etc/nagios.cfg

RUN echo "max_concurrent_checks=5" >> /opt/nagios/t/etc/nagios.cfg \
    && echo "event_broker_options=3" >> /opt/nagios/t/etc/nagios.cfg \
    && echo "vm.overcommit_memory=1" >> /etc/sysctl.conf

CMD ["/usr/local/nagios/bin/nagios", "--help"]