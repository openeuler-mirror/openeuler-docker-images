ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=3.2.1

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \
    fi && \
    curl -fSL --output grafana-logcli.rpm https://github.com/grafana/loki/releases/download/v${VERSION}/logcli-${VERSION}.${BUILDARCH}.rpm && \
    curl -fSL --output grafana-loki.rpm https://github.com/grafana/loki/releases/download/v${VERSION}/loki-${VERSION}.${BUILDARCH}.rpm && \
    curl -fSL --output grafana-promtail.rpm https://github.com/grafana/loki/releases/download/v${VERSION}/promtail-${VERSION}.${BUILDARCH}.rpm && \
    yum -y install grafana-loki.rpm grafana-promtail.rpm grafana-logcli.rpm && \
    rm -rf grafana-loki.rpm grafana-promtail.rpm grafana-logcli.rpm

COPY local-config.yaml /etc/loki/local-config.yaml

RUN groupadd -g 10001 loki && \
    adduser -u 10001 -g loki loki && \
    mkdir -p /loki/rules && \
    mkdir -p /loki/rules-temp && \
    chown -R loki:loki /etc/loki /loki

USER 10001
EXPOSE 3100
ENTRYPOINT [ "loki" ]
CMD ["-config.file=/etc/loki/local-config.yaml"]
