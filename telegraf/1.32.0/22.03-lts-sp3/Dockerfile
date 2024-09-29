ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.32.0

COPY telegraf.conf /etc/telegraf/

RUN yum -y install wget && \
    if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi && \
    wget -O /tmp/telegraf.rpm https://repos.influxdata.com/stable/${BUILDARCH}/main/telegraf-${VERSION}-1.${BUILDARCH}.rpm && \
    yum -y install /tmp/telegraf.rpm && \
    rm -f /tmp/telegraf.rpm && \
    yum remove -y wget && \
    yum clean all

EXPOSE 8094

CMD ["telegraf"]