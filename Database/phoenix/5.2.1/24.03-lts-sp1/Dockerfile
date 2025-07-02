ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=5.2.1

RUN curl -fSL -o phoenix.tar.gz https://dlcdn.apache.org/phoenix/phoenix-${VERSION}/phoenix-hbase-2.4-${VERSION}-bin.tar.gz && \
    tar -xvf phoenix.tar.gz -C /usr/local/ --strip-components=1

CMD ["bash"]