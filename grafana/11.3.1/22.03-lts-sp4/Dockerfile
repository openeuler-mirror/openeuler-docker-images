ARG BASE=openeuler/openeuler:22.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=11.3.1

COPY ./entrypoint.sh /
RUN yum -y update && \
    if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \ 
    fi && \
    yum install -y https://dl.grafana.com/enterprise/release/grafana-enterprise-${VERSION}-1.${BUILDARCH}.rpm && \
    yum clean all && \
    chmod 755 /entrypoint.sh


ENV PATH=/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
    GF_PATHS_DATA="/var/lib/grafana" \
    GF_PATHS_HOME="/usr/share/grafana" \
    GF_PATHS_LOGS="/var/log/grafana" \
    GF_PATHS_PLUGINS="/var/lib/grafana/plugins" \
    GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

EXPOSE 3000

USER grafana
ENTRYPOINT [ "/entrypoint.sh" ]
