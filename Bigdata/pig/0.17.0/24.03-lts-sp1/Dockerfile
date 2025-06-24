ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=0.17.0

RUN curl -fSL -o pig.tar.gz https://dlcdn.apache.org/pig/pig-${VERSION}/pig-${VERSION}.tar.gz; \
    mkdir -p /usr/local/pig && \
    tar -zxf pig.tar.gz -C /usr/local/pig --strip-components=1 && \
    rm -rf pig.tar.gz
ENV PATH=$PATH:/usr/local/pig/bin

RUN yum install -y java-17-openjdk-devel && \
    yum clean all
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk

# install dependent hadoop
ARG HADOOP_VERSION=3.4.1
RUN curl -fSL -o hadoop.tar.gz https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz; \
    mkdir -p /usr/local/hadoop && \
    tar -zxf hadoop.tar.gz -C /usr/local/hadoop --strip-components=1 && \
    rm -rf hadoop.tar.gz
ENV PATH=$PATH:/usr/local/hadoop/bin
ENV HADOOP_HOME=/usr/local/hadoop/

ENTRYPOINT ["pig", "-version"]