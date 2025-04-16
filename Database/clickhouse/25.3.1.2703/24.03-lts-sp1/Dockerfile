ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION="25.3.1.2703"


WORKDIR /tmp
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi; \
    curl -fSL -o clickhouse-server.rpm https://github.com/ClickHouse/ClickHouse/releases/download/v${VERSION}-lts/clickhouse-server-${VERSION}.${BUILDARCH}.rpm && \
    curl -fSL -o clickhouse-common-static.rpm https://github.com/ClickHouse/ClickHouse/releases/download/v${VERSION}-lts/clickhouse-common-static-${VERSION}.${BUILDARCH}.rpm  && \
    curl -fSL -o clickhouse-client.rpm https://github.com/ClickHouse/ClickHouse/releases/download/v${VERSION}-lts/clickhouse-client-${VERSION}.${BUILDARCH}.rpm

RUN yum install -y sudo shadow clickhouse-common-static.rpm clickhouse-server.rpm clickhouse-client.rpm && \
    yum clean all

COPY config.xml /etc/clickhouse-server/config.d/
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh && \
    mkdir -p /docker-entrypoint-initdb.d

EXPOSE 9000 8123 9009

ENTRYPOINT ["/entrypoint.sh"]