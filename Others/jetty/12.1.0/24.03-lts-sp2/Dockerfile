ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG VERSION=12.1.0

RUN dnf update -y \
    && dnf install -y wget git java-17-openjdk java-17-openjdk-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

WORKDIR /usr/local

ARG MAVEN_VERSION=3.9.11
RUN wget https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && mkdir -p /usr/local/maven \
    && tar -zxvf apache-maven-3.9.11-bin.tar.gz -C /usr/local/maven --strip-components=1

ENV PATH=/usr/local/maven/bin:$PATH

RUN git clone -b jetty-12.1.0 --depth 1  https://github.com/jetty/jetty.project \
    && cd jetty.project \
    && mvn -Pfast clean install
