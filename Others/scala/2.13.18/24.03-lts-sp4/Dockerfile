ARG BASE=openeuler/openeuler:24.03-lts-sp4
ARG VERSION=2.13.18

FROM ${BASE} AS builder

ARG VERSION

RUN curl -fSL --connect-timeout 30 --retry 3 --retry-delay 5 \
      -o /tmp/scala-${VERSION}.tgz \
      https://github.com/scala/scala/releases/download/v${VERSION}/scala-${VERSION}.tgz && \
    mkdir -p /opt/scala && \
    tar -xzf /tmp/scala-${VERSION}.tgz -C /opt/scala --strip-components=1 && \
    rm -f /tmp/scala-${VERSION}.tgz

FROM ${BASE}

RUN dnf install -y \
      java-17-openjdk-devel && \
    dnf clean all

COPY --from=builder /opt/scala /opt/scala

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH=$PATH:/opt/scala/bin

USER root

CMD ["scala"]
