ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=3.2.43

RUN yum install -y git maven java-17-openjdk-devel && \
    git clone -b ${VERSION} https://github.com/orientechnologies/orientdb.git

WORKDIR /orientdb
RUN mvn clean install -Dmaven.test.skip=true