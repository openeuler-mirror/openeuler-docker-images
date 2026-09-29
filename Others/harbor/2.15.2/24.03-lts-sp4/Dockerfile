ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=2.15.2
ARG GO_VERSION=1.26.4
ARG SWAGGER_VERSION=v0.33.1
ARG TARGETARCH

RUN dnf install -y \
      git curl tar gzip && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 -o go.tar.gz \
      https://dl.google.com/go/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    tar -xzf go.tar.gz -C /usr/local && \
    rm -f go.tar.gz

ENV PATH=/usr/local/go/bin:$PATH
ENV GOTOOLCHAIN=local
ENV CGO_ENABLED=0
ENV GOPROXY=https://goproxy.cn,direct
ENV GOBIN=/usr/local/bin

RUN for i in 1 2 3; do \
      git clone --branch v${VERSION} --depth 1 https://github.com/goharbor/harbor.git /harbor && break; \
      rm -rf /harbor; \
      sleep 5; \
    done && \
    test -d /harbor/.git

RUN go install github.com/go-swagger/go-swagger/cmd/swagger@${SWAGGER_VERSION}

RUN cd /harbor && \
    rm -rf src/server/v2.0/models src/server/v2.0/restapi && \
    swagger generate server \
      --template-dir=tools/swagger/templates \
      --exclude-main \
      --additional-initialism=CVE \
      --additional-initialism=GC \
      --additional-initialism=OIDC \
      -f api/v2.0/swagger.yaml \
      -A harbor \
      --target src/server/v2.0

RUN cd /harbor/src/core && \
    go build -buildvcs=false \
      --ldflags "-w -s -X github.com/goharbor/harbor/src/pkg/version.GitCommit=$(git -C /harbor rev-parse --short=8 HEAD) -X github.com/goharbor/harbor/src/pkg/version.ReleaseVersion=v${VERSION}" \
      -o /harbor/make/photon/core/harbor_core

FROM ${BASE}

ARG VERSION=2.15.2

RUN dnf install -y \
      ca-certificates \
      curl \
      shadow-utils \
      tzdata && \
    dnf clean all && \
    groupadd -r harbor && \
    useradd -r -g harbor -m harbor

COPY --from=builder /harbor/make/photon/core/harbor_core /harbor/
COPY --from=builder /harbor/make/photon/core/entrypoint.sh /harbor/
COPY --from=builder /harbor/make/photon/common/install_cert.sh /harbor/
COPY --from=builder /harbor/src/core/views /harbor/views
COPY --from=builder /harbor/make/migrations /harbor/migrations
COPY --from=builder /harbor/icons /harbor/icons
COPY --from=builder /harbor/LICENSE /usr/share/licenses/harbor/LICENSE

RUN chmod u+x /harbor/entrypoint.sh /harbor/install_cert.sh /harbor/harbor_core && \
    chown -R harbor:harbor /harbor

WORKDIR /harbor
USER harbor
EXPOSE 8080
HEALTHCHECK CMD curl --fail -s http://localhost:8080/api/v2.0/ping || curl -k --fail -s https://localhost:8443/api/v2.0/ping || exit 1
ENTRYPOINT ["/harbor/entrypoint.sh"]
