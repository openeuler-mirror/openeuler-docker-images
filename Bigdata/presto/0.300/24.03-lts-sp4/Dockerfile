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
            "${base}/com/facebook/presto/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz" \
            && gzip -t /tmp/presto-server.tar.gz; \
        then break; fi; \
    done; \
    mkdir -p /opt; \
    tar -xf /tmp/presto-server.tar.gz -C /opt; \
    rm -f /tmp/presto-server.tar.gz; \
    mv /opt/presto-server-${PRESTO_VERSION} /opt/presto

COPY <<'EOF' /opt/presto/etc/config.properties
coordinator=true
node-scheduler.include-coordinator=true
http-server.http.port=8080
query.max-memory=5GB
query.max-memory-per-node=1GB
discovery-server.enabled=true
discovery.uri=http://localhost:8080
EOF
COPY <<'EOF' /opt/presto/etc/jvm.config
-server
-Xmx16G
-XX:+UseG1GC
-XX:G1HeapRegionSize=32M
-XX:+UseGCOverheadLimit
-XX:+ExplicitGCInvokesConcurrent
-XX:+HeapDumpOnOutOfMemoryError
-XX:+ExitOnOutOfMemoryError
EOF
COPY <<'EOF' /opt/presto/etc/log.properties
com.facebook.presto=INFO
EOF
COPY <<'EOF' /opt/presto/etc/node.properties
node.environment=production
node.id=ffffffff-ffff-ffff-ffff-ffffffffffff
node.data-dir=/var/presto/data
EOF
COPY <<'EOF' /opt/presto/etc/catalog/tpch.properties
connector.name=tpch
EOF

RUN set -eux; \
    for url in \
        https://github.com/prestodb/presto/releases/download/${PRESTO_VERSION}/presto-cli-${PRESTO_VERSION}-executable.jar \
        https://maven.aliyun.com/repository/public/com/facebook/presto/presto-cli/${PRESTO_VERSION}/presto-cli-${PRESTO_VERSION}-executable.jar \
        https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/${PRESTO_VERSION}/presto-cli-${PRESTO_VERSION}-executable.jar; \
    do \
        if wget --tries=5 --waitretry=30 --timeout=60 -O /tmp/presto-cli.jar "$url" \
            && [ "$(stat -c %s /tmp/presto-cli.jar)" -gt 100000 ]; \
        then break; fi; \
    done; \
    mv /tmp/presto-cli.jar /usr/local/bin/presto; \
    chmod +x /usr/local/bin/presto

ENTRYPOINT ./opt/presto/bin/launcher run