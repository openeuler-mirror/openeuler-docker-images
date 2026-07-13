ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.6.0
ARG GO_VERSION=1.23.4
ARG SRIOV_URL=https://github.com/k8snetworkplumbingwg/sriov-network-operator/archive/refs/tags/v${VERSION}.tar.gz

WORKDIR /app

RUN dnf install -y curl && \
    curl -fSL -o go.tar.gz https://golang.google.cn/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    tar -xf go.tar.gz -C /usr/local && \
    rm -f go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
ENV GO111MODULE=on
ENV CGO_ENABLED=0

RUN curl -fSL ${SRIOV_URL} -o sriov.tar.gz && \
    tar -xzf sriov.tar.gz && \
    cd sriov-network-operator-${VERSION} && \
    GOARCH=${TARGETARCH} go build -ldflags "-s -w" -o /usr/local/bin/sriov-network-operator main.go && \
    GOARCH=${TARGETARCH} go build -ldflags "-s -w" -o /usr/local/bin/sriov-network-config-daemon ./cmd/sriov-network-config-daemon/ && \
    GOARCH=${TARGETARCH} go build -ldflags "-s -w" -o /usr/local/bin/sriov-network-webhook ./cmd/webhook/ && \
    GOARCH=${TARGETARCH} go build -ldflags "-s -w" -o /usr/local/bin/sriov-network-operator-config-cleanup ./cmd/sriov-network-operator-config-cleanup/ && \
    cd /app && \
    rm -rf sriov-network-operator-* sriov.tar.gz && \
    dnf clean all

ENV OPERATOR_NAME=sriov-network-operator
CMD ["/usr/local/bin/sriov-network-operator"]
