ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG TARGETARCH
ARG VERSION=6.2.6

RUN dnf update -y \
    && dnf install -y java-17-openjdk gettext wget \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

ARG MAVEN_VERSION=3.9.11
RUN wget https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && mkdir -p /usr/local/maven \
    && tar -zxvf apache-maven-3.9.11-bin.tar.gz -C /usr/local/maven --strip-components=1

ENV PATH=/usr/local/maven/bin:$PATH

WORKDIR /home/spring-framework
COPY example src/main/java/com/example
COPY pom.xml.template pom.xml.template

ENV SPRING_VERSION=${VERSION}

RUN envsubst < pom.xml.template > pom.xml \
    && mvn clean compile dependency:build-classpath -Dmdep.outputFile=target/classpath.txt

CMD CLASS_PATH="target/classes:$(cat target/classpath.txt)" && \
    java -cp "$CLASS_PATH" com.example.MainApp