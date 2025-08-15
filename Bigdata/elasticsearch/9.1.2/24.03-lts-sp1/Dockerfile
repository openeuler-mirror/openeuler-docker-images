ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} AS builder

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=9.1.2
ARG TINI_VERSION=0.19.0

RUN curl --retry 10 -S -L -O https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-${TARGETARCH} ; \
    curl --retry 10 -S -L -O https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-${TARGETARCH}.sha256sum ; \
    sha256sum -c tini-${TARGETARCH}.sha256sum ; \
    rm tini-${TARGETARCH}.sha256sum ; \
    mv tini-${TARGETARCH} /bin/tini ; \
    chmod 0555 /bin/tini

RUN mkdir /usr/share/elasticsearch
WORKDIR /usr/share/elasticsearch

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi; \
    curl --retry 10 -S -L --output /tmp/elasticsearch.tar.gz https://artifacts-no-kpi.elastic.co/downloads/elasticsearch/elasticsearch-${VERSION}-linux-${BUILDARCH}.tar.gz

RUN tar -zxf /tmp/elasticsearch.tar.gz --strip-components=1

COPY config/elasticsearch.yml config/
COPY config/log4j2.properties config/log4j2.docker.properties

RUN yum install -y findutils
RUN sed -i -e 's/ES_DISTRIBUTION_TYPE=tar/ES_DISTRIBUTION_TYPE=docker/' bin/elasticsearch-env && \
    mkdir data && \
    mv config/log4j2.properties config/log4j2.file.properties && \
    mv config/log4j2.docker.properties config/log4j2.properties && \
    find . -type d -exec chmod 0555 {} + && \
    find . -type f -exec chmod 0444 {} + && \
    chmod 0555 bin/* jdk/bin/* jdk/lib/jspawnhelper modules/x-pack-ml/platform/linux-*/bin/* && \
    chmod 0775 bin config config/jvm.options.d data logs plugins && \
    find config -type f -exec chmod 0664 {} +


FROM ${BASE}

RUN yum install -y shadow findutils nc p11-kit unzip zip && yum clean all
RUN groupadd -g 1000 elasticsearch && \
    useradd -u 1000 -g 1000 -d /usr/share/elasticsearch -m elasticsearch && \
    usermod -aG root elasticsearch && \
    chown -R 0:0 /usr/share/elasticsearch

ENV ELASTIC_CONTAINER true
WORKDIR /usr/share/elasticsearch
COPY --from=builder --chown=0:0 /usr/share/elasticsearch /usr/share/elasticsearch
COPY --from=builder --chown=0:0 /bin/tini /bin/tini
ENV PATH /usr/share/elasticsearch/bin:$PATH
ENV SHELL /bin/bash
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod g=u /etc/passwd && \
    chmod 0555 /usr/local/bin/entrypoint.sh && \
    find / -xdev -perm -4000 -exec chmod ug-s {} + && \
    chmod 0775 /usr/share/elasticsearch && \
    chown elasticsearch bin config config/jvm.options.d data logs plugins

EXPOSE 9200 9300

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["eswrapper"]
USER 1000:0