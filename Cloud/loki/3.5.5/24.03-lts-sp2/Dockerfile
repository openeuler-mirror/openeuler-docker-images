ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=3.5.5

RUN dnf install -y shadow-utils && dnf clean all

RUN curl -fSL --output logcli-linux.zip https://github.com/grafana/loki/releases/download/v${VERSION}/logcli-linux-${TARGETARCH}.zip && \
    curl -fSL --output loki-linux.rpm https://github.com/grafana/loki/releases/download/v${VERSION}/loki-linux-${TARGETARCH}.zip && \
    curl -fSL --output promtail-linux.zip https://github.com/grafana/loki/releases/download/v${VERSION}/promtail-linux-${TARGETARCH}.zip && \
    mv logcli-linux-${TARGETARCH} /usr/local/bin/logcli && \
    mv loki-linux-${TARGETARCH} /usr/local/bin/loki && \
    mv promtail-linux-${TARGETARCH} /usr/local/bin/promtail && \
    rm -rf loki-linux.zip promtail-linux.zip logcli-linux.zip

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