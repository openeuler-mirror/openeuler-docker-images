ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=2.12.0

RUN curl -fSL -o parquet.tar.gz https://archive.apache.org/dist/parquet/apache-parquet-format-${VERSION}/apache-parquet-format-${VERSION}.tar.gz; \
    mkdir -p /usr/local/parquet && \
    tar -zxf parquet.tar.gz -C /usr/local/parquet --strip-components=1 && \
    rm -rf parquet.tar.gz
ENV PATH=$PATH:/usr/local/parquet/bin

ENTRYPOINT [ "parquet", "--version" ]