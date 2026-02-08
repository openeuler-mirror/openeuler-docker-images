ARG BASE=openeuler/openeuler:24.03-lts-sp3
ARG VERSION=0.44.7

FROM grafana/agent:v${VERSION} AS source

FROM ${BASE}

COPY --from=source /usr/bin/grafana-agent /usr/bin/grafana-agent
COPY agent.yaml /etc/agent/agent.yaml

ENTRYPOINT ["grafana-agent"]
CMD ["--config.file=/etc/agent/agent.yaml", "--metrics.wal-directory=/etc/agent/data"]
