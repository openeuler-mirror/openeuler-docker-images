ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=2.5.0

RUN curl https://get.netdata.cloud/kickstart.sh > /opt/netdata-kickstart.sh

WORKDIR /opt

RUN chmod +x ./netdata-kickstart.sh

CMD ["./netdata-kickstart.sh", "--non-interactive"]