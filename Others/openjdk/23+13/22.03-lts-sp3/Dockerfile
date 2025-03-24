ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=23+13

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \
    fi && \
    curl -fSL --output openjdk.tar.gz https://download.java.net/java/early_access/jdk${VERSION%%+*}/${VERSION#*+}/GPL/openjdk-${VERSION%%+*}-ea+${VERSION#*+}_linux-${BUILDARCH}_bin.tar.gz && \
    mkdir -p /usr/local/java/ && tar -xvf openjdk.tar.gz -C /usr/local/java --strip-components=1 && \
    rm -f openjdk.tar.gz

ENV JAVA_HOME=/usr/local/java/
ENV PATH=$JAVA_HOME/bin:$PATH
ENV CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

CMD ["bash"]
