ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=2.16.0

RUN yum -y update && yum -y install wget && yum clean all && \
    wget -O mimir.rpm https://github.com/grafana/mimir/releases/download/mimir-${VERSION}/mimir-${VERSION}_${TARGETARCH}.rpm && \
    yum -y install mimir.rpm && \
    rm -rf mimir.rpm

EXPOSE 8080
ENTRYPOINT ["mimir"]
