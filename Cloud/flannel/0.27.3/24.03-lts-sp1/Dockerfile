ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG CGOFLAG=0
ARG VERSION=0.27.3
ARG GO_VERSION=1.23.7
ARG FLANNEL_URL=https://github.com/flannel-io/flannel/archive/refs/tags/v${VERSION}.tar.gz

WORKDIR /app

RUN curl -fSL -o go.tar.gz https://golang.google.cn/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    tar -xvf go.tar.gz -C /usr/local

ENV PATH="/usr/local/go/bin:${PATH}"

RUN yum install -y conntrack-tools ipset net-tools

RUN if [ ${TARGETARCH} = "amd64" ]; then \
        CGOFLAG=1; \
        yum install -y gcc ; \
    fi && \
    curl -fSL ${FLANNEL_URL} -o flannel.tar.gz && \
    tar -xzf flannel.tar.gz && \
    cd flannel-* && \
    CGO_ENABLED=${CGOFLAG} go build && \
    cp flannel /usr/bin/ && \
    cd .. && \
    rm -rf flannel-* flannel.tar.gz && \
    yum clean all && \
    chmod a+x /usr/bin/flannel

ENTRYPOINT ["/usr/bin/flannel"]