ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=4.1.0

RUN curl -fSL --connect-timeout 30 --retry 3 \
      -o /tmp/taskflow.tar.gz \
      https://github.com/taskflow/taskflow/archive/refs/tags/v${VERSION}.tar.gz && \
    tar -zxf /tmp/taskflow.tar.gz -C /tmp

FROM ${BASE}

ARG VERSION=4.1.0

RUN dnf install -y gcc-c++ && dnf clean all

COPY --from=builder /tmp/taskflow-${VERSION}/taskflow /usr/local/include/taskflow
COPY --from=builder /tmp/taskflow-${VERSION}/LICENSE /usr/local/share/licenses/taskflow/LICENSE

USER root
