ARG BASE=openeuler/openeuler:22.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=3.8.0

ARG SCALA_VERSION=2.13
ARG KAFKA_URL=https://archive.apache.org/dist/kafka/${VERSION}/kafka_${SCALA_VERSION}-${VERSION}.tgz 

RUN yum -y install wget hostname java-1.8.0-openjdk java-1.8.0-openjdk-devel
RUN mkdir opt/kafka; \
    wget -O kafka.tgz "${KAFKA_URL}"; \
    tar xfz kafka.tgz -C /opt/kafka --strip-components 1; \
    mkdir -p /var/lib/kafka/data /etc/kafka/secrets; \
    mkdir -p /etc/kafka/docker /usr/logs /mnt/shared/config; \
    useradd -d /home/appuser -m -s /bin/bash appuser; \
    chown appuser:appuser -R /usr/logs /opt/kafka /mnt/shared/config; \
    chown appuser:root -R /var/lib/kafka /etc/kafka/secrets /etc/kafka; \
    chmod -R ug+w /etc/kafka /var/lib/kafka /etc/kafka/secrets; \
    cp /opt/kafka/config/log4j.properties /etc/kafka/docker/log4j.properties; \
    cp /opt/kafka/config/tools-log4j.properties /etc/kafka/docker/tools-log4j.properties; \
    cp /opt/kafka/config/kraft/server.properties /etc/kafka/docker/server.properties; \
    rm kafka.tgz; \
    yum remove wget findutils; \
    yum clean all

COPY --chown=appuser:appuser scripts /etc/kafka/docker
COPY --chown=appuser:appuser launch /etc/kafka/docker/launch
RUN chmod 755 /etc/kafka/docker/run

EXPOSE 9092
USER appuser

VOLUME ["/etc/kafka/secrets", "/var/lib/kafka/data", "/mnt/shared/config"]
CMD ["/etc/kafka/docker/run"]