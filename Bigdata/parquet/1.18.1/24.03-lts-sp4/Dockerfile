ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE

ARG VERSION=1.18.1

RUN curl -fSL -o parquet.tar.gz https://archive.apache.org/dist/parquet/apache-parquet-${VERSION}/apache-parquet-${VERSION}.tar.gz; \
    mkdir -p /usr/local/parquet && \
    tar -zxf parquet.tar.gz -C /usr/local/parquet --strip-components=1 && \
    rm -rf parquet.tar.gz
ENV PATH=$PATH:/usr/local/parquet/bin

ENTRYPOINT [ "parquet", "--version" ]