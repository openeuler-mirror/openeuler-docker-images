ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG VERSION=2.1.0
ARG TARGETARCH

# Install dependencies
RUN dnf install -y java-21-openjdk-headless \
    wget \
    gpg \
    gettext \
    jemalloc \
    snappy \
    shadow-utils \
    util-linux  \
    coreutils \
    hostname \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

# Grab gosu for easy step-down from root
ENV GOSU_VERSION 1.11
RUN wget -nv -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${TARGETARCH}" && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true

# Configure Flink version
ENV FLINK_TGZ_URL=https://dlcdn.apache.org/flink/flink-${VERSION}/flink-${VERSION}-bin-scala_2.12.tgz
ENV FLINK_HOME=/opt/flink
ENV PATH=/opt/flink/bin:$PATH

# Prepare environment
RUN groupadd -g 9999 flink && \
    useradd -u 9999 -g flink -d $FLINK_HOME -s /sbin/nologin flink

WORKDIR $FLINK_HOME

# Install Flink
RUN set -ex && \
    wget -nv -O flink.tgz "$FLINK_TGZ_URL" && \
    tar -xf flink.tgz --strip-components=1 && \
    rm flink.tgz && \
    chown -R flink:flink .; \
    # Replace default REST/RPC endpoint bind address to use the container's network interface \
    CONF_FILE="${FLINK_HOME}/conf/config.yaml"; \
    /bin/bash "$FLINK_HOME/bin/config-parser-utils.sh" "${FLINK_HOME}/conf" "${FLINK_HOME}/bin" "${FLINK_HOME}/lib" \
        "-repKV" "rest.address,localhost,0.0.0.0" \
        "-repKV" "rest.bind-address,localhost,0.0.0.0" \
        "-repKV" "jobmanager.bind-host,localhost,0.0.0.0" \
        "-repKV" "taskmanager.bind-host,localhost,0.0.0.0" \
        "-rmKV" "taskmanager.host=localhost";

# Configure container
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 6123 8081
CMD ["help"]

