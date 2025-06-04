ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=10.2.1

# setup java env
RUN yum install -y java-21-openjdk-devel util-linux xorg-x11-server-Xvfb && \
    yum clean all
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk

# install lucene
RUN curl -fSL -o lucene.tar.gz https://dlcdn.apache.org/lucene/java/${VERSION}/lucene-${VERSION}.tgz; \
    mkdir -p /usr/local/lucene && \
    tar -zxf lucene.tar.gz -C /usr/local/lucene --strip-components=1 && \
    rm -rf lucene.tar.gz
COPY luke.sh /usr/local/lucene/bin/
RUN chmod +x /usr/local/lucene/bin/luke.sh

WORKDIR /usr/local/lucene/bin