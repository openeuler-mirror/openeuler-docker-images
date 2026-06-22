ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=0.4.1

WORKDIR /app

RUN dnf install -y curl make git && \
    curl -fSL -o go.tar.gz https://golang.google.cn/dl/go1.21.13.linux-${TARGETARCH}.tar.gz && \
    tar -xf go.tar.gz -C /usr/local && \
    rm -f go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
ENV CGO_ENABLED=0
ENV GO111MODULE=on

RUN git clone --depth 1 --branch socialNetwork-${VERSION} \
        https://github.com/delimitrou/DeathStarBench.git && \
    cd DeathStarBench/hotelReservation && \
    GOARCH=${TARGETARCH} GOBIN=/usr/local/bin \
        go install -ldflags="-s -w" -mod=vendor ./cmd/... && \
    cd /app && \
    rm -rf DeathStarBench && \
    dnf clean all

CMD ["frontend"]
