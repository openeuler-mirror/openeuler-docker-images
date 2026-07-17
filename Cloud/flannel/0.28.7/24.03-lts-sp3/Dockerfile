ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE} AS builder

ARG TARGETARCH
ARG CGOFLAG=0
ARG VERSION=0.28.7
ARG GO_VERSION=1.25.12
ARG FLANNEL_URL=https://github.com/flannel-io/flannel/archive/refs/tags/v${VERSION}.tar.gz

WORKDIR /app

RUN dnf install -y curl conntrack-tools ipset net-tools && \
    curl -fSL -o go.tar.gz https://golang.google.cn/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    tar -xzf go.tar.gz -C /usr/local && \
    rm -f go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

RUN if [ ${TARGETARCH} = "amd64" ]; then \
        CGOFLAG=1; \
        dnf install -y gcc; \
    fi && \
    curl -fSL ${FLANNEL_URL} -o flannel.tar.gz && \
    tar -xzf flannel.tar.gz && \
    cd flannel-* && \
    CGO_ENABLED=${CGOFLAG} go build && \
    cp flannel /usr/bin/ && \
    cd /app && \
    rm -rf flannel-* flannel.tar.gz && \
    dnf remove -y gcc curl || true && \
    dnf clean all && \
    chmod a+x /usr/bin/flannel

ENTRYPOINT ["/usr/bin/flannel"]
CMD ["--help"]
