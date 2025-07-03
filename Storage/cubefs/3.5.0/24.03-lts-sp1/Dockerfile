ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} AS builder

ARG TARGETARCH
ARG VERSION=3.5.0
ARG GO_VERSION=1.17

WORKDIR /app
RUN yum install -y git make cmake g++ maven && \
    yum clean all && \
    curl -fSL -o go.tar.gz https://golang.google.cn/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    tar -xvf go.tar.gz -C /usr/local && \
    rm -rf go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

RUN git clone -b v${VERSION} https://github.com/cubefs/cubefs.git && \
    cd cubefs && \
    make 


FROM ${BASE}

COPY --from=builder /usr/local/go /usr/local/go
COPY --from=builder /app/cubefs/build/bin/* /usr/local/bin/

WORKDIR /usr/local/bin