ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=9.9.0
WORKDIR /

RUN yum install -y java-11-openjdk-devel shadow sudo lsof
RUN url="https://www.apache.org/dyn/closer.lua/solr/solr/${VERSION}/solr-${VERSION}.tgz?action=download"; \
    curl --retry 10 -S -L -o solr.tgz "$url"

RUN tar -zxf solr.tgz && \
    if [ -d apache-solr-$VERSION ]; then \
        mv -iv apache-solr-${VERSION} solr-${VERSION}; \
    fi && \
    test -d "solr-$VERSION" && \
    ln -sv "solr-$VERSION" solr && \
    rm -fv solr.tgz && \
    rm -rf solr/doc

ENV PATH=$PATH:/solr/bin

RUN useradd -r -s /bin/bash solr && \
    chown -R solr /solr* && \
    yum remove -y shadow && \
    yum clean all

EXPOSE 8983 8984 9983