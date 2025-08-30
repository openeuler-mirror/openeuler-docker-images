# Copyright (C) 2025 Neo Technology, Inc.
# SPDX-License-Identifier: Apache-2.0

ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM $BASE
ARG VERSION=2025.08.0
ARG MAVEN_VERSION=3.9.1

RUN yum install -y java-21-openjdk java-21-openjdk-devel git && \
    curl -fSL -o apache-maven.tar.gz https://repo.huaweicloud.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mkdir -p /usr/local/maven && \
    tar -zxf apache-maven.tar.gz -C /usr/local/maven --strip-components=1 && \
    rm -rf apache-maven.tar.gz
ENV PATH=$PATH:/usr/local/maven/bin

RUN git clone -b ${VERSION} https://github.com/neo4j/neo4j.git && \
    cd neo4j && \
    mvn clean install -T4C -DskipTests && \
    cd /neo4j/packaging/standalone/target/ && \
    tar -xvf neo4j-community-${VERSION}-unix.tar.gz
ENV NEO4J_HOME=/neo4j/packaging/standalone/target/neo4j-community-${VERSION}

RUN curl -fSL -o ${NEO4J_HOME}/lib/neo4j-browser-5.9.0.jar https://repo.maven.apache.org/maven2/org/neo4j/client/neo4j-browser/5.9.0/neo4j-browser-5.9.0.jar && \
    sed -i '$a\server.memory.pagecache.size=512M' ${NEO4J_HOME}/conf/neo4j.conf && \
    sed -i '$a\server.default_listen_address=0.0.0.0' ${NEO4J_HOME}/conf/neo4j.conf

ENV PATH=$PATH:${NEO4J_HOME}/bin
WORKDIR ${NEO4J_HOME}

EXPOSE 7474 7687 7473
CMD ["neo4j", "console"]
