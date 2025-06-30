ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=3.4.1

COPY ssh/* /etc/ssh/
COPY entrypoint.sh /
RUN yum install -y java-11-openjdk-devel openssh openssh-clients sudo hostname && \
    yum clean all && \
    ssh-keygen -A && ssh-keygen -t ed25519 -P '' -f /root/.ssh/id_ed25519 && \
    cat /root/.ssh/id_ed25519.pub > /root/.ssh/authorized_keys && \
    chmod 0400 /root/.ssh/authorized_keys && \
    chmod +x /entrypoint.sh

RUN curl -fSL -o hadoop.tar.gz https://dlcdn.apache.org/hadoop/common/hadoop-${VERSION}/hadoop-${VERSION}.tar.gz; \
    mkdir -p /usr/local/hadoop && \
    tar -zxf hadoop.tar.gz -C /usr/local/hadoop --strip-components=1 && \
    rm -rf hadoop.tar.gz
ENV PATH=$PATH:/usr/local/hadoop/bin
ENV HADOOP_HOME=/usr/local/hadoop
COPY hadoop/* $HADOOP_HOME/etc/hadoop/

EXPOSE 9870 8088 19888 50070 50075 50010 50020 50090
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "start" ]