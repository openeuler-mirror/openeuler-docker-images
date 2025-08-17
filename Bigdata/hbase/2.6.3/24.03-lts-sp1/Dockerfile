ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=2.6.3

RUN curl -fSL -o hbase.tar.gz https://dlcdn.apache.org/hbase/${VERSION}/hbase-${VERSION}-bin.tar.gz; \
    mkdir -p /usr/local/hbase && \
    tar -zxf hbase.tar.gz -C /usr/local/hbase --strip-components=1 && \
    rm -rf hbase.tar.gz

ENV PATH=$PATH:/usr/local/hbase/bin

RUN yum install -y java-11-openjdk-devel findutils && \
    yum clean all

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

EXPOSE 8080 8085 9090 9095 2181 16010
ENTRYPOINT ["hbase", "version"]