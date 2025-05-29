ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=1.11.0

RUN curl -fSL -o flume.tar.gz https://dlcdn.apache.org/flume/${VERSION}/apache-flume-${VERSION}-bin.tar.gz; \
    mkdir -p /usr/local/flume && \
    tar -zxf flume.tar.gz -C /usr/local/flume --strip-components=1 && \
    rm -rf flume.tar.gz

ENV PATH=$PATH:/usr/local/flume/bin

RUN yum install -y java-17-openjdk-devel && \
    yum clean all

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk

ENTRYPOINT ["flume-ng", "version"]