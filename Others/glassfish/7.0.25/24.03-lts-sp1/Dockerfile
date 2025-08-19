ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=7.0.25

RUN yum install -y java-17-openjdk-devel git && \
    yum clean all && \
    cd / && \
    curl -fSL -o apache-maven.tar.gz https://repo.huaweicloud.com/apache/maven/maven-3/3.9.3/binaries/apache-maven-3.9.3-bin.tar.gz && \
    mkdir -p /usr/local/maven && \
    tar -zxf apache-maven.tar.gz -C /usr/local/maven --strip-components=1 && \
    rm -rf apache-maven.tar.gz

ENV MAVEN_HOME=/usr/local/maven
ENV PATH=${MAVEN_HOME}/bin:$PATH

WORKDIR /
RUN git clone -b ${VERSION} https://github.com/eclipse-ee4j/glassfish.git && \
    cd glassfish && \
    mvn clean install -Pfastest -T4C