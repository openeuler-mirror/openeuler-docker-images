ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=1.35.0
ARG TARGETARCH
ARG BUILDARCH

RUN dnf update -y \
    && dnf install -y wget \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /usr/local/envoy

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch_64"; \
    fi; \
    wget -O envoy https://github.com/envoyproxy/envoy/releases/download/v${VERSION}/envoy-${VERSION}-linux-${BUILDARCH} \
    && chmod +x envoy

WORKDIR /usr/local/envoy

CMD ["./envoy", "--help"]