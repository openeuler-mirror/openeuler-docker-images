ARG BASE=openeuler/openeuler:24.03-lts
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=2.54.1

RUN yum -y update && yum -y install wget && yum clean all && \
    wget -O prometheus.tar.gz https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-${TARGETARCH}.tar.gz && \
    mkdir /prometheus && tar -zxvf prometheus.tar.gz -C /prometheus --strip-components 1 && \
    rm -f prometheus.tar.gz

RUN mkdir -p /etc/prometheus/ /usr/share/prometheus/                                    && \
    mv /prometheus/prometheus               /bin/prometheus                             && \
    mv /prometheus/promtool                 /bin/promtool                               && \
    mv /prometheus/prometheus.yml           /etc/prometheus/prometheus.yml              && \
    mv /prometheus/console_libraries/       /usr/share/prometheus/console_libraries/    && \
    mv /prometheus/consoles/                /usr/share/prometheus/consoles/             && \
    mv /prometheus/LICENSE                  /LICENSE                                    && \
    mv /prometheus/NOTICE                   /NOTICE                                     && \
    rm -rf /prometheus/

WORKDIR /prometheus
RUN groupadd -r prometheus && useradd -r -g prometheus prometheus && \
    ln -s /usr/share/prometheus/console_libraries /usr/share/prometheus/consoles/ /etc/prometheus/ && \
    chown -R prometheus:prometheus /etc/prometheus /prometheus 

USER       prometheus
EXPOSE     9090
VOLUME     [ "/prometheus" ]
ENTRYPOINT [ "/bin/prometheus" ]
CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
             "--storage.tsdb.path=/prometheus", \
             "--web.console.libraries=/usr/share/prometheus/console_libraries", \
             "--web.console.templates=/usr/share/prometheus/consoles" ]
