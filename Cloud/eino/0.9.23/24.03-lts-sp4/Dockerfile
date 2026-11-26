ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG TARGETARCH
ARG VERSION=0.9.23
ARG GO_VERSION=1.24.4

RUN dnf install -y \
        curl git \
        gzip tar && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 -o /tmp/go.tar.gz \
        https://golang.google.cn/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    tar -xzf /tmp/go.tar.gz -C /usr/local && \
    rm -f /tmp/go.tar.gz

ENV PATH=/usr/local/go/bin:${PATH}
ENV GOPATH=/go
ENV GOTOOLCHAIN=local
ENV CGO_ENABLED=0

RUN curl -fSL --connect-timeout 30 --retry 3 -o /tmp/eino.tar.gz \
        https://github.com/cloudwego/eino/archive/refs/tags/v${VERSION}.tar.gz && \
    mkdir -p /src/eino && \
    tar -xzf /tmp/eino.tar.gz -C /src/eino --strip-components=1 && \
    rm -f /tmp/eino.tar.gz

WORKDIR /src/eino

RUN go mod download && \
    go build ./...

FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

RUN dnf install -y \
        curl git \
        gzip tar && \
    dnf clean all

COPY --from=builder /usr/local/go /usr/local/go
COPY --from=builder /go/pkg/mod /go/pkg/mod
COPY --from=builder /src/eino /eino

ENV PATH=/usr/local/go/bin:/go/bin:${PATH}
ENV GOPATH=/go
ENV GOTOOLCHAIN=local
ENV CGO_ENABLED=0
ENV GO111MODULE=on

WORKDIR /eino

USER root

CMD ["go", "version"]
