ARG BASE=openeuler/openeuler:24.03-lts
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=0.44.2
    
RUN curl -fSL --output grafana-agent.rpm https://github.com/grafana/agent/releases/download/v${VERSION}/grafana-agent-${VERSION}-1.${TARGETARCH}.rpm && \
    yum -y install grafana-agent.rpm && \
    rm -rf grafana-agent.rpm

COPY agent.yaml /etc/agent/agent.yaml

ENTRYPOINT ["grafana-agent"]
CMD ["--config.file=/etc/agent/agent.yaml", "--metrics.wal-directory=/etc/agent/data"]
