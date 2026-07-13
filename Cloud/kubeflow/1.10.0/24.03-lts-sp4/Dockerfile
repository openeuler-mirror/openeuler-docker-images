ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.10.0
ARG GO_VERSION=1.21.13
ARG KUBEFLOW_URL=https://github.com/kubeflow/kubeflow/archive/refs/tags/v${VERSION}.tar.gz

WORKDIR /app

RUN dnf install -y curl make git && \
    curl -fSL -o go.tar.gz https://golang.google.cn/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    tar -xf go.tar.gz -C /usr/local && \
    rm -f go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
ENV CGO_ENABLED=0
ENV GO111MODULE=on

RUN curl -fSL ${KUBEFLOW_URL} -o kubeflow.tar.gz && \
    tar -xzf kubeflow.tar.gz && \
    cd kubeflow-${VERSION}/components/notebook-controller && \
    go mod edit -replace github.com/kubeflow/kubeflow/components/common=../common && \
    GOARCH=${TARGETARCH} go build -a -mod=mod -o /usr/local/bin/notebook-controller main.go && \
    cd /app/kubeflow-${VERSION}/components/profile-controller && \
    GOARCH=${TARGETARCH} go build -a -mod=mod -o /usr/local/bin/profile-controller main.go && \
    cd /app && \
    rm -rf kubeflow-* kubeflow.tar.gz && \
    dnf clean all

CMD ["notebook-controller"]
