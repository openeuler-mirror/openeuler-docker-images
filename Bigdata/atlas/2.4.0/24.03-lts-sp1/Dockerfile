ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=2.4.0

RUN yum install -y git maven java-1.8.0-openjdk-devel make gcc g++ hostname && \
    yum clean all

ENV MAVEN_OPTS="-Xms8g -Xmx8g"
RUN git clone -b release-${VERSION} https://github.com/apache/atlas.git && \
    cd /atlas && \
    mvn clean install -DskipTests -T 2C && \
    mvn clean \
        -Dhttps.protocols=TLSv1.2 \
        -DskipTests \
        -Drat.skip=true \
        package -Pdist,embedded-hbase-solr && \
    mkdir -p /atlas-server && \
    tar -xzvf /atlas/distro/target/apache-atlas-${VERSION}-server.tar.gz -C /atlas-server --strip-components=1 && \
    echo -e 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk' >> /atlas-server/conf/atlas-env.sh && \
    mkdir -p /atlas-server/hbase/conf/ && \
    cp /atlas/dev-support/atlas-docker/scripts/hbase-site.xml /atlas-server/hbase/conf/ && \
    rm -rf /atlas

COPY atlas_config.patch /atlas-server/
WORKDIR /atlas-server
RUN yum install -y patch && \
    patch -p1 < atlas_config.patch

EXPOSE 21000