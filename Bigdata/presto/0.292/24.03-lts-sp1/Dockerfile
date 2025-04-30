ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG PRESTO_VERSION=0.292

RUN yum install -y java-1.8.0-openjdk python wget tar less

RUN wget https://repo1.maven.org/maven2/com/facebook/presto/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz \
    && mkdir -p /opt \
    && tar -xf presto-server-${PRESTO_VERSION}.tar.gz -C /opt \
    && rm -f presto-server-${PRESTO_VERSION}.tar.gz \
    && mv /opt/presto-server-${PRESTO_VERSION} /opt/presto

COPY etc /opt/presto/etc

RUN wget https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/${PRESTO_VERSION}/presto-cli-${PRESTO_VERSION}-executable.jar \
	&& mv presto-cli-${PRESTO_VERSION}-executable.jar /usr/local/bin/presto \
	&& chmod +x /usr/local/bin/presto

ENTRYPOINT ./opt/presto/bin/launcher run
