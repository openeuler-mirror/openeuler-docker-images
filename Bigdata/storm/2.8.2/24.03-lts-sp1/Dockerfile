ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=2.8.2
ARG GOSU_VERSION=1.17
ARG TARGETARCH

RUN curl -fSL -o storm.tar.gz https://archive.apache.org/dist/storm/apache-storm-${VERSION}/apache-storm-${VERSION}.tar.gz; \
    mkdir -p /usr/local/storm && \
    tar -zxf storm.tar.gz -C /usr/local/storm --strip-components=1 && \
    rm -rf storm.tar.gz && \
    curl -fSL -o /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}.asc" && \
	curl -fSL -o /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}" && \
    chmod +x /usr/local/bin/gosu.asc && \
    chmod +x /usr/local/bin/gosu

ENV PATH=$PATH:/usr/local/storm/bin
ENV STORM_CONF_DIR=/conf
ENV STORM_DATA_DIR=/data
ENV STORM_LOG_DIR=/logs
COPY entrypoint.sh /
RUN yum install -y java-17-openjdk-devel shadow-utils && \
    yum clean all && \
    chmod +x /entrypoint.sh && \
    groupadd -r storm --gid=1000; \
    useradd -r -g storm --uid=1000 storm; \
    mkdir -p "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"; \
    chown -R storm:storm "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
WORKDIR /usr/local/storm/
ENTRYPOINT ["/entrypoint.sh"]