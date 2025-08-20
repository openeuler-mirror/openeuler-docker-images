ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE} AS builder

ARG VERSION=2.524
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

FROM ${BASE}
COPY --from=builder /jenkins/war/target/jenkins.war /jenkins/jenkins.war

RUN dnf update -y \
    && dnf install -y java-17-openjdk \
    && dnf clean all \
    && rm -rf /var/run/dnf/*

WORKDIR /jenkins

CMD ["java", "-jar", "./jenkins.war"]
