ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=3.31.0
ARG GO_VERSION=1.25.10

WORKDIR /app

RUN dnf install -y curl make git gcc && \
    curl -fSL -o go.tar.gz https://golang.google.cn/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    tar -xf go.tar.gz -C /usr/local && \
    rm -f go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
ENV GO111MODULE=on

RUN git clone --depth 1 --branch ${VERSION} \
        https://github.com/kata-containers/kata-containers.git && \
    cd kata-containers/src/runtime && \
    make SKIP_GO_VERSION_CHECK=true runtime containerd-shim-v2 monitor && \
    cp kata-runtime containerd-shim-kata-v2 kata-monitor /usr/local/bin/ && \
    cd /app && \
    rm -rf kata-containers && \
    dnf clean all

CMD ["kata-runtime", "--help"]
