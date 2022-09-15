FROM openeuler/openeuler:22.03-lts
MAINTAINER heguofeng <heguofeng@openeuler.sh>
RUN yum -y update && \
    yum -y install prometheus2 && \
    yum clean all

WORKDIR /prometheus
RUN ln -s /usr/share/prometheus/console_libraries /usr/share/prometheus/consoles/ /etc/prometheus/ && \
    chown -R prometheus:prometheus /etc/prometheus /prometheus

USER prometheus

VOLUME  [ "/prometheus" ]
EXPOSE 9090
ENTRYPOINT [ "/bin/prometheus" ]
CMD  [ "--config.file=/etc/prometheus/prometheus.yml", \
       "--storage.tsdb.path=/prometheus", \
       "--web.console.libraries=/usr/share/prometheus/console_libraries", \
       "--web.console.templates=/usr/share/prometheus/consoles" ]
