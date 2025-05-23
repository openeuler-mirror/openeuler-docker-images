ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} AS builder

ARG VERSION=9.0.1
ARG TARGETARCH
ARG BUILDARCH
ARG GO_VERSION=1.24.1

RUN dnf update -y \
    && dnf install -y make gcc-c++ python3 wget \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="amd64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="arm64"; \
    fi; \
    wget https://go.dev/dl/go${GO_VERSION}.linux-${BUILDARCH}.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-${BUILDARCH}.tar.gz \
    && rm -f go${GO_VERSION}.linux-${BUILDARCH}.tar.gz

ENV PATH=/usr/local/go/bin:$PATH

RUN wget https://github.com/elastic/beats/archive/refs/tags/v${VERSION}.tar.gz \
    && tar -zxvf v${VERSION}.tar.gz \
    && rm -f v${VERSION}.tar.gz

WORKDIR /opt/beats-${VERSION}/filebeat

RUN make -j \
    && mv filebeat /usr/local/bin/

FROM ${BASE}

COPY --from=builder /usr/local/bin/filebeat /usr/local/bin/filebeat

CMD ["filebeat", "--help"]
