ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=5.1
ARG URL=https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mongoose/mongoose-${VERSION}.tgz

RUN yum install -y make gcc-c++ openssl-devel  && \
    yum clean all

WORKDIR /mongoose
RUN curl -o mongoose.tgz ${URL} && \
    tar -zxf mongoose.tgz --strip-components=1 && \
    rm -rf mongoose.tgz

WORKDIR /mongoose/examples
RUN make