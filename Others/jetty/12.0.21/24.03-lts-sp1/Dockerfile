ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as builder
ARG VERSION=12.0.21
ARG TARGETARCH
ARG BUILDARCH

ARG JDK_VERSION=17.0.15_6
ARG MAVEN_VERSION=3.9.2

RUN dnf update -y \
    && dnf install -y wget git \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /usr/local

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \
    fi \
    && wget https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jdk/${BUILDARCH}/linux/OpenJDK17U-jdk_${BUILDARCH}_linux_hotspot_${JDK_VERSION}.tar.gz \
    && tar -zxvf OpenJDK17U-jdk_${BUILDARCH}_linux_hotspot_${JDK_VERSION}.tar.gz \
    && rm -f OpenJDK17U-jdk_${BUILDARCH}_linux_hotspot_${JDK_VERSION}.tar.gz \
    && wget https://repo.huaweicloud.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar -zxvf apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz

ENV JAVA_HOME=/usr/local/jdk-17.0.15+6
ENV PATH=${JAVA_HOME}/bin:$PATH

ENV MAVEN_HOME=/usr/local/apache-maven-${MAVEN_VERSION}
ENV PATH=${MAVEN_HOME}/bin:$PATH

RUN git clone -b jetty-12.0.21 --depth 1  https://github.com/jetty/jetty.project \
    && cd jetty.project \
    && mvn -Pfast clean install
