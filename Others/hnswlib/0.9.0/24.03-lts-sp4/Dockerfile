ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=0.9.0

RUN curl -fSL --connect-timeout 30 --retry 3 \
      -o /tmp/hnswlib.tar.gz \
      https://github.com/nmslib/hnswlib/archive/refs/tags/v${VERSION}.tar.gz && \
    tar -zxf /tmp/hnswlib.tar.gz -C /tmp

FROM ${BASE}

ARG VERSION=0.9.0

RUN dnf install -y gcc-c++ && \
    dnf clean all

COPY --from=builder /tmp/hnswlib-${VERSION}/hnswlib /usr/local/include/hnswlib
COPY --from=builder /tmp/hnswlib-${VERSION}/LICENSE /usr/local/share/licenses/hnswlib/LICENSE

USER root

CMD ["bash"]
