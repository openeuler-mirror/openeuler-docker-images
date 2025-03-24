ARG BASE=openeuler/openeuler:24.03-lts
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=0.28.0-rc.0

RUN yum update -y && yum install -y wget && \
    wget -O alertmanager.tar.gz https://github.com/prometheus/alertmanager/releases/download/v${VERSION}/alertmanager-${VERSION}.linux-${TARGETARCH}.tar.gz && \
    mkdir /alertmanager && tar -zxvf alertmanager.tar.gz -C /alertmanager --strip-components 1

RUN mkdir -p /etc/alertmanager                              && \
    mv /alertmanager/amtool             /bin/amtool         && \
    mv /alertmanager/alertmanager       /bin/alertmanager   && \
    mv /alertmanager/alertmanager.yml   /etc/alertmanager/alertmanager.yml && \
    rm -rf /alertmanager

RUN mkdir -p /alertmanager && \
    groupadd -r alertmanager && useradd -r -g alertmanager alertmanager && \
    chown -R alertmanager:alertmanager etc/alertmanager /alertmanager

USER       alertmanager
EXPOSE     9093
VOLUME     [ "/alertmanager" ]
WORKDIR    /alertmanager
ENTRYPOINT [ "/bin/alertmanager" ]
CMD        [ "--config.file=/etc/alertmanager/alertmanager.yml", "--storage.path=/alertmanager" ]
