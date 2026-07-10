ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.0.8
ARG GO_VERSION=1.23.7
ARG FLUID_URL=https://github.com/fluid-cloudnative/fluid/archive/refs/tags/v${VERSION}.tar.gz

WORKDIR /app

RUN dnf install -y curl make git && \
    curl -fSL -o go.tar.gz https://golang.google.cn/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    tar -xf go.tar.gz -C /usr/local && \
    rm -f go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
ENV CGO_ENABLED=0
ENV GO111MODULE=on

RUN curl -fSL ${FLUID_URL} -o fluid.tar.gz && \
    tar -xzf fluid.tar.gz && \
    cd fluid-${VERSION} && \
    GOARCH=${TARGETARCH} go build -a -o /usr/local/bin/dataset-controller cmd/dataset/main.go && \
    GOARCH=${TARGETARCH} go build -a -o /usr/local/bin/fluidapp-controller cmd/fluidapp/main.go && \
    GOARCH=${TARGETARCH} go build -a -o /usr/local/bin/fluid-webhook cmd/webhook/main.go && \
    GOARCH=${TARGETARCH} go build -a -o /usr/local/bin/fluid-csi cmd/csi/main.go && \
    cd /app && \
    rm -rf fluid-* fluid.tar.gz && \
    dnf clean all

CMD ["dataset-controller", "start"]
