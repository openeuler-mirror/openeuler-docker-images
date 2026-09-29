ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=9.8.0

RUN dnf install -y \
      curl unzip && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 5 --retry-delay 5 \
      -o /tmp/gradle-${VERSION}-bin.zip \
      https://services.gradle.org/distributions/gradle-${VERSION}-bin.zip && \
    echo "bafd5ce9cfaea0fbccfdc8439a1ac42fbd4cd9c89dc9a988228d8a2639a58e6c  /tmp/gradle-${VERSION}-bin.zip" | sha256sum -c - && \
    unzip -q /tmp/gradle-${VERSION}-bin.zip -d /opt/gradle && \
    rm -f /tmp/gradle-${VERSION}-bin.zip

FROM ${BASE}

ARG VERSION=9.8.0

RUN dnf install -y \
      java-21-openjdk-headless && \
    dnf clean all

COPY --from=builder /opt/gradle/gradle-${VERSION} /opt/gradle

ENV GRADLE_HOME=/opt/gradle
ENV PATH=${GRADLE_HOME}/bin:${PATH}

USER root
WORKDIR /workspace

CMD ["gradle", "--version"]
