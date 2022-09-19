FROM openeuler/openeuler:22.03-lts
MAINTAINER heguofeng <heguofeng@openeuler.sh>

RUN yum -y update && \
    yum -y install sudo hostname && \
    yum -y install rabbitmq-server && \
    rabbitmq-plugins enable --offline rabbitmq_prometheus && \
    mkdir -p /etc/rabbitmq/conf.d  && \
    echo 'management_agent.disable_metrics_collector = true' > /etc/rabbitmq/conf.d/management_agent.disable_metrics_collector.conf && \
    chown rabbitmq:rabbitmq /etc/rabbitmq  -R  && \
    ln -sf /usr/lib/rabbitmq/lib/rabbitmq_server-3.9.10/plugins /plugins && \
    yum clean all

ENV EXEC_GOSU="gosu-amd64"

RUN if [ "`arch`" == "x86_64" ]; then EXEC_GOSU="gosu-amd64"; else EXEC_GOSU="gosu-arm64"; fi 

COPY $EXEC_GOSU  /usr/local/bin/gosu

ENV RABBITMQ_DATA_DIR=/var/lib/rabbitmq
ENV HOME $RABBITMQ_DATA_DIR
VOLUME $RABBITMQ_DATA_DIR

ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8

COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 5672 15672
CMD ["rabbitmq-server"]
