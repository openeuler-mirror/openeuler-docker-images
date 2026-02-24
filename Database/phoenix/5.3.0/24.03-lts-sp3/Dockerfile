ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=5.3.0

RUN curl -fSL -o phoenix.tar.gz https://archive.apache.org/dist/phoenix/phoenix-${VERSION}/phoenix-hbase-2.5-${VERSION}-bin.tar.gz && \
    tar -xvf phoenix.tar.gz -C /usr/local/ --strip-components=1

CMD ["bash"]