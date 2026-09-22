ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=9.7.1

RUN dnf install -y \
      curl unzip && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 5 --retry-delay 5 \
      -o /tmp/gradle-${VERSION}-bin.zip \
      https://services.gradle.org/distributions/gradle-${VERSION}-bin.zip && \
    echo "acd53f1edaf02f1a8ff99879f8a34b302661a057d9b063ae9e35b552f804d20a  /tmp/gradle-${VERSION}-bin.zip" | sha256sum -c - && \
    unzip -q /tmp/gradle-${VERSION}-bin.zip -d /opt/gradle && \
    rm -f /tmp/gradle-${VERSION}-bin.zip

FROM ${BASE}

ARG VERSION=9.7.1

RUN dnf install -y \
      java-21-openjdk-headless && \
    dnf clean all

COPY --from=builder /opt/gradle/gradle-${VERSION} /opt/gradle

ENV GRADLE_HOME=/opt/gradle
ENV PATH=${GRADLE_HOME}/bin:${PATH}

USER root
WORKDIR /workspace

CMD ["gradle", "--version"]
