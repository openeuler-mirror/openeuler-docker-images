ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=5.0.5

RUN yum -y install java && \
    yum clean all

RUN groupadd --system --gid 1000 cassandra && \
    useradd --system --gid cassandra --uid 1000 cassandra

RUN curl -o /tmp/cassandra-${VERSION}.tar.gz https://dlcdn.apache.org/cassandra/${VERSION}/apache-cassandra-${VERSION}-bin.tar.gz && \
    tar -zxvf /tmp/cassandra-${VERSION}.tar.gz -C /tmp && \
    cd /tmp/apache-cassandra-${VERSION}/bin && \
    rm -rf /tmp/cassandra-${VERSION}.tar.gz

EXPOSE 7000 7001 7199 9042 9160

WORKDIR /tmp/apache-cassandra-${VERSION}/bin

CMD ["./cassandra", "-f", "-R"] 
