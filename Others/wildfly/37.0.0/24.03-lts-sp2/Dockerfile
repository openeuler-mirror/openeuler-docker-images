ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG VERSION=37.0.0
ARG WILDFLY_HOME=/opt/wildfly

RUN dnf install -y wget shadow-utils java-17-openjdk java-17-openjdk-devel  \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

USER root

RUN mkdir -p ${WILDFLY_HOME} \
    && groupadd -r wildfly -g 1000 \
    && useradd -u 1000 -r -g wildfly -d ${WILDFLY_HOME} wildfly \
    && chown -R wildfly:wildfly ${WILDFLY_HOME}

USER wildfly

WORKDIR ${WILDFLY_HOME}

RUN wget https://github.com/wildfly/wildfly/releases/download/${VERSION}.Final/wildfly-${VERSION}.Final.tar.gz \
    && tar -zxvf wildfly-${VERSION}.Final.tar.gz --strip-components=1 \
    && rm -f wildfly-${VERSION}.Final.tar.gz

ENV LAUNCH_JBOSS_IN_BACKGROUND true

EXPOSE 8080

CMD ["./bin/standalone.sh", "-b", "0.0.0.0"]