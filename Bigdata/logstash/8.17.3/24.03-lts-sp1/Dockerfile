ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=8.17.3

RUN yum install -y shadow procps findutils tar gzip glibc-langpack-en
RUN groupadd -g 1000 logstash && \
    useradd -u 1000 -g 1000 -d /usr/share/logstash -M logstash

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi; \
    curl --retry 10 -s -L --output /tmp/logstash.tar.gz https://artifacts.elastic.co/downloads/logstash/logstash-${VERSION}-linux-${BUILDARCH}.tar.gz

WORKDIR /usr/share/logstash
RUN tar -zxf /tmp/logstash.tar.gz -C /usr/share/logstash --strip-components=1 && \
    chown --recursive logstash:logstash /usr/share/logstash/ && \
    chown -R logstash:root /usr/share/logstash && \
    chmod -R g=u /usr/share/logstash && \
    mkdir /licenses/ && \
    mv /usr/share/logstash/NOTICE.TXT /licenses/NOTICE.TXT && \
    mv /usr/share/logstash/LICENSE.txt /licenses/LICENSE.txt && \
    find /usr/share/logstash -type d -exec chmod g+s {} \; && \
    ln -s /usr/share/logstash /opt/logstash


ENV ELASTIC_CONTAINER true
ENV PATH=/usr/share/logstash/bin:$PATH
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

COPY entrypoint.sh /usr/local/bin/
COPY config/logstash-full.yml config/logstash.yml
COPY config/pipelines.yml config/log4j2.properties config/log4j2.file.properties config/
COPY config/default.conf pipeline/logstash.conf
COPY env2yaml/env2yaml-${TARGETARCH} /usr/local/bin/env2yaml

RUN chown --recursive logstash:root config/ pipeline/
RUN chmod 0755 /usr/local/bin/entrypoint.sh && \
    chmod 0755 /usr/local/bin/env2yaml

USER 1000
EXPOSE 9600 5044
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]