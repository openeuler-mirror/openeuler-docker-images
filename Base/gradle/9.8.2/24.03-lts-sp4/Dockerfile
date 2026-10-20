ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=9.8.2

RUN dnf install -y \
      curl unzip && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 5 --retry-delay 5 \
      -o /tmp/gradle-${VERSION}-bin.zip \
      https://services.gradle.org/distributions/gradle-${VERSION}-bin.zip && \
    echo "dce76f55f8e251a3a1f130eb120f30b3d271de2b76c9b0729d316b5a1b6dc01f  /tmp/gradle-${VERSION}-bin.zip" | sha256sum -c - && \
    unzip -q /tmp/gradle-${VERSION}-bin.zip -d /opt/gradle && \
    rm -f /tmp/gradle-${VERSION}-bin.zip

FROM ${BASE}

ARG VERSION=9.8.2

RUN dnf install -y \
      java-21-openjdk-headless && \
    dnf clean all

COPY --from=builder /opt/gradle/gradle-${VERSION} /opt/gradle

ENV GRADLE_HOME=/opt/gradle
ENV PATH=${GRADLE_HOME}/bin:${PATH}

USER root
WORKDIR /workspace

CMD ["gradle", "--version"]