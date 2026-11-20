ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE} AS builder

ARG VERSION=3.0.0
ARG MAVEN_VERSION=3.9.9

ARG AMBARI_URL=https://archive.apache.org/dist/ambari/ambari-${VERSION}/apache-ambari-${VERSION}-src.tar.gz

RUN yum install -y wget curl java-17-openjdk java-17-openjdk-devel nodejs npm git && \
    npm install -g bower && \
    curl -fSL -o apache-maven.tar.gz https://repo.huaweicloud.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mkdir -p /usr/local/maven && \
    tar -zxf apache-maven.tar.gz -C /usr/local/maven --strip-components=1 && \
    rm -rf apache-maven.tar.gz
    
ENV PATH=$PATH:/usr/local/maven/bin

RUN wget -O /tmp/ambari.tar.gz "${AMBARI_URL}" && \
    mkdir -p /opt/ambari-src && \
    tar xfz /tmp/ambari.tar.gz -C /opt/ambari-src --strip-components 1 && \
    rm /tmp/ambari.tar.gz

RUN echo '{"registry":"https://registry.bower.io","strict-ssl":false}' > /opt/ambari-src/ambari-admin/src/main/resources/ui/admin-web/.bowerrc

WORKDIR /opt/ambari-src
RUN mvn -B clean install package \
    -Drat.skip=true \
    -DskipTests \
    -Dmaven.test.skip=true \
    -Dfindbugs.skip=true \
    -Dcheckstyle.skip=true \
    -Dmaven.repo.local=/tmp/maven-repo

FROM ${BASE}

RUN yum install -y java-17-openjdk java-17-openjdk-devel python3 && \
    yum clean all

COPY --from=builder /opt/ambari-src /opt/ambari

ENV AMBARI_HOME=/opt/ambari
WORKDIR /opt/ambari

EXPOSE 8080

CMD ["python3", "ambari-server/src/main/python/ambari-server.py", "start"]
