ARG BASE=openeuler/openeuler:24.03-lts-sp1

FROM ${BASE} as builder
ARG VERSION=34.0.0
ARG DRUID_HOME=/opt/druid

RUN dnf install -y wget

RUN wget https://dlcdn.apache.org/druid/${VERSION}/apache-druid-${VERSION}-bin.tar.gz \
    && tar -zxvf apache-druid-${VERSION}-bin.tar.gz \
    && mv apache-druid-${VERSION} ${DRUID_HOME} \
    && rm -f apache-druid-${VERSION}-bin.tar.gz


FROM ${BASE}
ARG DRUID_HOME=/opt/druid
ARG DRUID_UID=1000
ARG DRUID_GID=1000

RUN dnf install -y java-17-openjdk-headless busybox iproute shadow-utils perl && \
    dnf clean all

RUN groupadd -g ${DRUID_GID} druid && \
    useradd -u ${DRUID_UID} -g druid -d ${DRUID_HOME} -s /bin/bash druid

RUN mkdir -p /opt/druid/log && \
    chown -R druid:druid ${DRUID_HOME} && \
    chmod 775 /opt/druid/log

COPY --from=builder --chown=druid:druid ${DRUID_HOME} ${DRUID_HOME}

USER druid
WORKDIR ${DRUID_HOME}

ENTRYPOINT ["./bin/start-druid"]