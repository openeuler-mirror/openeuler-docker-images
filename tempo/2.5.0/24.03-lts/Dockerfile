ARG BASE=openeuler/openeuler:24.03-lts
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=2.5.0

RUN yum -y install wget && \
    wget -O /tmp/tempo.rpm https://github.com/grafana/tempo/releases/download/v${VERSION}/tempo_${VERSION}_linux_${TARGETARCH}.rpm && \
    yum -y install /tmp/tempo.rpm && \
    rm -f /tmp/tempo.rpm && \
    yum remove -y wget && \
    yum clean all

ENTRYPOINT ["tempo", "-config.file", "/etc/tempo/config.yml"]
