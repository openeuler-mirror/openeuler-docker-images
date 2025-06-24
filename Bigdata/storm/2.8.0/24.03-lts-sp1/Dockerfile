ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=2.8.0

RUN curl -fSL -o storm.tar.gz https://dlcdn.apache.org/storm/apache-storm-${VERSION}/apache-storm-${VERSION}.tar.gz; \
    mkdir -p /usr/local/storm && \
    tar -zxf storm.tar.gz -C /usr/local/storm --strip-components=1 && \
    rm -rf storm.tar.gz

ENV PATH=$PATH:/usr/local/storm/bin

RUN yum install -y java-17-openjdk-devel && \
    yum clean all

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk

ENTRYPOINT ["storm", "version"]