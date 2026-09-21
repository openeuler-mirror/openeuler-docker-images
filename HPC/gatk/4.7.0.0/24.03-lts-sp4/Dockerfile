ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=4.7.0.0

RUN dnf install -y \
        curl unzip && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 -o /tmp/gatk-${VERSION}.zip \
        https://github.com/broadinstitute/gatk/releases/download/${VERSION}/gatk-${VERSION}.zip && \
    mkdir -p /opt/gatk && \
    unzip -q /tmp/gatk-${VERSION}.zip -d /tmp/gatk && \
    cp -a /tmp/gatk/gatk-${VERSION}/. /opt/gatk/ && \
    chmod 0755 /opt/gatk/gatk && \
    rm -rf /tmp/gatk /tmp/gatk-${VERSION}.zip

FROM ${BASE}

ARG VERSION=4.7.0.0

RUN dnf install -y \
        java-17-openjdk && \
    dnf clean all && \
    ln -sf /usr/bin/python3 /usr/bin/python

COPY --from=builder /opt/gatk /opt/gatk

ENV PATH=/opt/gatk:$PATH \
    GATK_LOCAL_JAR=/opt/gatk/gatk-package-${VERSION}-local.jar \
    GATK_SPARK_JAR=/opt/gatk/gatk-package-${VERSION}-spark.jar

WORKDIR /data

USER root
CMD ["/bin/bash"]
