ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=2.523
ARG MAVEN_VERSION=3.9.6
ARG MAVEN_URL=https://repo.huaweicloud.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz

RUN yum install -y java-17-openjdk-devel git && \
    yum clean all && \
    curl -fSL -o apache-maven.tar.gz ${MAVEN_URL} && \
    mkdir -p /usr/local/maven && \
    tar -zxf apache-maven.tar.gz -C /usr/local/maven --strip-components=1 && \
    rm -rf apache-maven.tar.gz

ENV PATH=$PATH:/usr/local/maven/bin

RUN git clone -b jenkins-${VERSION} https://github.com/jenkinsci/jenkins.git && \
    cd jenkins && \
    mvn clean install -Dmaven.test.skip=true