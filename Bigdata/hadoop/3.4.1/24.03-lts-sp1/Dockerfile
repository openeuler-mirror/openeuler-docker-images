ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=3.4.1

RUN curl -fSL -o hadoop.tar.gz https://dlcdn.apache.org/hadoop/common/hadoop-${VERSION}/hadoop-${VERSION}.tar.gz; \
    mkdir -p /usr/local/hadoop && \
    tar -zxf hadoop.tar.gz -C /usr/local/hadoop --strip-components=1 && \
    rm -rf hadoop.tar.gz

ENV PATH=$PATH:/usr/local/hadoop/bin

RUN yum install -y java-11-openjdk-devel && \
    yum clean all

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

ENTRYPOINT ["hadoop", "version"]