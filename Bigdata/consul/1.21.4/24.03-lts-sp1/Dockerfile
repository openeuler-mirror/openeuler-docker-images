ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=1.21.4

RUN yum install -y golang && \
    yum clean all

RUN curl -fSL -o consul.tar.gz https://github.com/hashicorp/consul/archive/refs/tags/v${VERSION}.tar.gz && \
    tar -zxvf consul.tar.gz && \
    cd consul-${VERSION} && \
    go build && \
    cp consul /usr/bin/ && \
    cd .. && \
    rm -rf consul-${VERSION} consul.tar.gz

WORKDIR /usr/bin
EXPOSE 8500 8600
ENTRYPOINT ["consul"]
