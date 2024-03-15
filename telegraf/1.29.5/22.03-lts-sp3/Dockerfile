ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.29.5

RUN yum -y install wget && \
    yum clean all

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi && \
    wget -O /tmp/telegraf.rpm https://repos.influxdata.com/stable/${BUILDARCH}/main/telegraf-${VERSION}-1.${BUILDARCH}.rpm && \
    yum -y install /tmp/telegraf.rpm && \
    rm -f /tmp/telegraf.rpm

EXPOSE 8092/udp 8094 8125/udp

CMD ["telegraf"]