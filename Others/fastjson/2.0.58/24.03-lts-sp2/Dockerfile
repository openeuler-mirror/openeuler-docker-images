ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE} as BUILDER
ARG VERSION=2.0.58

RUN dnf install -y java-17-openjdk java-17-openjdk-devel gettext wget \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

ARG MAVEN_VERSION=3.9.11
RUN wget https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && mkdir -p /usr/local/maven \
    && tar -zxvf apache-maven-3.9.11-bin.tar.gz -C /usr/local/maven --strip-components=1

ENV PATH=/usr/local/maven/bin:$PATH

ENV LANG="C.UTF-8"

WORKDIR /home/fastjson
COPY Fastjson2Demo.java src/main/java/com/example/Fastjson2Demo.java
COPY pom.xml.template pom.xml.template

ENV FAST_JSON_VERSION=${VERSION}

RUN envsubst < pom.xml.template > pom.xml \
    && mvn clean compile -Dfile.encoding=UTF-8

CMD mvn exec:java -Dexec.mainClass="com.example.Fastjson2Demo"