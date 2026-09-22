ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=2026.04.30

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"

RUN dnf install -y \
      java-17-openjdk-devel \
      tar gzip findutils which && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 2 \
      -o /tmp/jvarkit.tar.gz \
      https://github.com/lindenb/jvarkit/archive/refs/tags/v${VERSION}.tar.gz && \
    curl -fSL --connect-timeout 30 --retry 2 \
      -o /tmp/bcfparser.tar.gz \
      https://github.com/lindenb/bcfparser/archive/36b3bb13096431c75277ed8cf5426ea4e7534939.tar.gz && \
    mkdir -p /tmp/jvarkit-src/bcfparser && \
    tar xzf /tmp/jvarkit.tar.gz -C /tmp/jvarkit-src --strip-components=1 && \
    tar xzf /tmp/bcfparser.tar.gz -C /tmp/jvarkit-src/bcfparser --strip-components=1 && \
    cd /tmp/jvarkit-src && \
    chmod +x gradlew && \
    ./gradlew --no-daemon -Djvarkit.disable.test=true -Djvarkit.generate.doc=false jvarkit && \
    mkdir -p /opt/jvarkit/dist && \
    cp dist/jvarkit.jar /opt/jvarkit/dist/jvarkit.jar && \
    rm -rf /tmp/jvarkit.tar.gz /tmp/bcfparser.tar.gz /tmp/jvarkit-src

FROM ${BASE}

RUN dnf install -y \
      java-17-openjdk-headless && \
    dnf clean all

COPY --from=builder /opt/jvarkit /opt/jvarkit

ENV JVARKIT_DIST=/opt/jvarkit/dist
ENV JVARKIT_JAR=/opt/jvarkit/dist/jvarkit.jar

USER root
WORKDIR /data
CMD ["/bin/bash"]
