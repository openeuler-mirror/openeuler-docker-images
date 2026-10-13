ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH

ARG VERSION=3.10.0

RUN yum update -y && \
    yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel jq wget tar gzip && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN wget -q https://archive.apache.org/dist/maven/maven-3/${VERSION}/binaries/apache-maven-${VERSION}-bin.tar.gz -O /tmp/apache-maven.tar.gz && \
    mkdir -p /opt && \
    tar -zxf /tmp/apache-maven.tar.gz -C /opt && \
    rm -f /tmp/apache-maven.tar.gz && \
    ln -s /opt/apache-maven-${VERSION} /opt/maven

ENV MAVEN_HOME=/opt/maven
ENV PATH=${MAVEN_HOME}/bin:${PATH}

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]