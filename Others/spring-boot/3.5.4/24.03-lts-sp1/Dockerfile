ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE} as Builder
ARG VERSION=3.5.4

RUN dnf update -y  \
    && dnf install -y wget gettext java-17-openjdk java-17-openjdk-devel \
    && dnf clean all \
    && rm -rf /var/run/cache/*

ARG MAVEN_VERSION=3.9.11
RUN wget https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && mkdir -p /usr/local/maven \
    && tar -zxvf apache-maven-3.9.11-bin.tar.gz -C /usr/local/maven --strip-components=1

ENV PATH=/usr/local/maven/bin:$PATH

COPY Application.java /spring-boot/src/main/java/com/spring/boot/Application.java
COPY pom.xml.template /spring-boot/pom.xml.template

ENV SPRING_BOOT_VERSION=${VERSION}

WORKDIR spring-boot

RUN envsubst < pom.xml.template > pom.xml \
    && mvn clean install package -Dmaven.test.skip


FROM ${BASE}

RUN yum update -y \
    && yum install -y wget java-17-openjdk

ENV WORKSPACE=/home/spring-boot

WORKDIR ${WORKSPACE}

COPY --chown=spring-boot --from=Builder /spring-boot/target ${WORKSPACE}/target

ENV LANG="C.UTF-8"

EXPOSE 8080

CMD java -jar ${WORKSPACE}/target/demo-1.0.jar