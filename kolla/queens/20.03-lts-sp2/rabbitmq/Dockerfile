FROM openeuler/openeuler-binary-base:queens-20.03-lts-sp2

RUN usermod --append --home /var/lib/rabbitmq --groups kolla rabbitmq \
    && mkdir -p /var/lib/rabbitmq \
    && chown -R 42439:42439 /var/lib/rabbitmq

RUN yum -y install erlang-hipe hostname rabbitmq-server && yum clean all && rm -rf /var/cache/yum

RUN rabbitmq-plugins list | grep rabbitmq_management &>/dev/null \
    && rabbitmq-plugins enable rabbitmq_management \
    && ln -s `rpm -ql rabbitmq-server | grep cuttlefish` /usr/lib/rabbitmq/bin/cuttlefish \
    && rm -f /etc/rabbitmq/rabbitmq.config

COPY extend_start.sh /usr/local/bin/kolla_extend_start
COPY rabbitmq_get_gospel_node.py /usr/local/bin/rabbitmq_get_gospel_node
RUN chmod 755 /usr/local/bin/kolla_extend_start /usr/local/bin/rabbitmq_get_gospel_node

USER rabbitmq
