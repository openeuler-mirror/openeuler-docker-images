ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.6.2
ARG GO_VERSION=1.25.0
ARG KUBERAY_URL=https://github.com/ray-project/kuberay/archive/refs/tags/v${VERSION}.tar.gz

WORKDIR /app

RUN dnf install -y curl make git && \
    curl -fSL -o go.tar.gz https://golang.google.cn/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    tar -xf go.tar.gz -C /usr/local && \
    rm -f go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
ENV CGO_ENABLED=0
ENV GO111MODULE=on

RUN curl -fSL ${KUBERAY_URL} -o kuberay.tar.gz && \
    tar -xzf kuberay.tar.gz && \
    cd kuberay-${VERSION}/ray-operator && \
    GOARCH=${TARGETARCH} go build -a -o /usr/local/bin/kuberay-operator main.go && \
    cd /app/kuberay-${VERSION}/apiserver && \
    GOARCH=${TARGETARCH} go build -a -o /usr/local/bin/kuberay-apiserver ./cmd/ && \
    cd /app && \
    rm -rf kuberay-* kuberay.tar.gz && \
    dnf clean all

CMD ["kuberay-operator"]
