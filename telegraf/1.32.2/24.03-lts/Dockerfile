ARG BASE=openeuler/openeuler:24.03-lts
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.32.2

COPY telegraf.conf /etc/telegraf/

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi && \
    curl -fSL --output /tmp/telegraf.rpm https://repos.influxdata.com/stable/${BUILDARCH}/main/telegraf-${VERSION}-1.${BUILDARCH}.rpm && \
    yum -y install /tmp/telegraf.rpm && \
    rm -f /tmp/telegraf.rpm

EXPOSE 8094

CMD ["telegraf"]