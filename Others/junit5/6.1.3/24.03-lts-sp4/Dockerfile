ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=6.1.3

WORKDIR /junit

RUN curl -fSL --connect-timeout 30 --retry 5 -o junit-platform-console-standalone-${VERSION}.jar \
      https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/${VERSION}/junit-platform-console-standalone-${VERSION}.jar && \
    curl -fSL --connect-timeout 30 --retry 5 -o junit-platform-console-standalone-${VERSION}.jar.sha256 \
      https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/${VERSION}/junit-platform-console-standalone-${VERSION}.jar.sha256 && \
    echo "$(cat junit-platform-console-standalone-${VERSION}.jar.sha256)  junit-platform-console-standalone-${VERSION}.jar" | sha256sum -c -

FROM ${BASE}

ARG VERSION=6.1.3

RUN dnf install -y java-17-openjdk-headless && \
    dnf clean all

COPY --from=builder /junit/junit-platform-console-standalone-${VERSION}.jar /usr/local/lib/junit-platform-console-standalone.jar

ENV LANG=C.UTF-8

WORKDIR /workspace

USER root

ENTRYPOINT ["java", "-jar", "/usr/local/lib/junit-platform-console-standalone.jar"]
