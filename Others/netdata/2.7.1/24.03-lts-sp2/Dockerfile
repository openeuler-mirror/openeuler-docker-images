ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG VERSION=2.7.1

RUN dnf update -y && dnf install -y shadow-utils findutils

RUN groupadd --system netdata && useradd --system -g netdata -s /sbin/nologin -M netdata

RUN curl https://get.netdata.cloud/kickstart.sh > /opt/netdata-kickstart.sh

WORKDIR /opt

RUN chmod +x ./netdata-kickstart.sh

RUN ./netdata-kickstart.sh --non-interactive --no-updates

CMD ["./netdata/bin/netdata", "--help"]