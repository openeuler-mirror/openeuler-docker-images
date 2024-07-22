ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=3.9.2

RUN yum -y install java && \
    yum clean all

RUN curl -o /tmp/zookeeper.tar.gz https://archive.apache.org/dist/zookeeper/zookeeper-${VERSION}/apache-zookeeper-${VERSION}-bin.tar.gz && \
    tar -zxvf /tmp/zookeeper.tar.gz -C /tmp && \
    cd /tmp/apache-zookeeper-${VERSION}-bin/conf && \
    touch zoo.cfg && echo -e 'tickTime=2000\ndataDir=/var/lib/zookeeper\nclientPort=2181\nadmin.serverPort=8081' > zoo.cfg

WORKDIR /tmp/apache-zookeeper-${VERSION}-bin/

EXPOSE 2181

CMD ["bin/zkServer.sh", "start-foreground"]