ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG VERSION=4.2.4.Final

RUN dnf update -y \
    && dnf install -y wget java-17-openjdk java-17-openjdk-devel gettext \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

ARG MAVEN_VERSION=3.9.11
RUN wget https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && mkdir -p /usr/local/maven \
    && tar -zxvf apache-maven-3.9.11-bin.tar.gz -C /usr/local/maven --strip-components=1

ENV PATH=/usr/local/maven/bin:$PATH

WORKDIR /opt/netty

COPY NettyDemo.java src/main/java/demo/NettyDemo.java
COPY pom.xml.template pom.xml.template

ENV NETTY_VERSION=${VERSION}

RUN envsubst < pom.xml.template > pom.xml \
    && mvn clean package -Dfile.encoding=UTF-8

CMD ["java", "-cp", "target/netty-demo-1.0-SNAPSHOT.jar", "demo.NettyDemo"]
