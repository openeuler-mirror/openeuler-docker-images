ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG PRESTO_VERSION=0.299

RUN yum install -y java-1.8.0-openjdk python wget tar less

RUN set -eux; \
    for base in \
        https://maven.aliyun.com/repository/public \
        https://mirrors.huaweicloud.com/maven \
        https://repo1.maven.org/maven2; \
    do \
        if wget --tries=5 --waitretry=30 --timeout=60 -O /tmp/presto-server.tar.gz \
            "${base}/com/facebook/presto/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz"; \
        then break; fi; \
    done; \
    mkdir -p /opt; \
    tar -xf /tmp/presto-server.tar.gz -C /opt; \
    rm -f /tmp/presto-server.tar.gz; \
    mv /opt/presto-server-${PRESTO_VERSION} /opt/presto

COPY etc /opt/presto/etc

RUN set -eux; \
    for base in \
        https://maven.aliyun.com/repository/public \
        https://mirrors.huaweicloud.com/maven \
        https://repo1.maven.org/maven2; \
    do \
        if wget --tries=5 --waitretry=30 --timeout=60 -O /tmp/presto-cli.jar \
            "${base}/com/facebook/presto/presto-cli/${PRESTO_VERSION}/presto-cli-${PRESTO_VERSION}-executable.jar"; \
        then break; fi; \
    done; \
    mv /tmp/presto-cli.jar /usr/local/bin/presto; \
    chmod +x /usr/local/bin/presto

ENTRYPOINT ./opt/presto/bin/launcher run
