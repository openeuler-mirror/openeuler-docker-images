ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=8u412

ENV JAVA_HOME /usr/lib/jvm/java-openjdk-${VERSION}
ENV PATH $JAVA_HOME/bin:$PATH
ENV LANG C.UTF-8
ENV JAVA_VERSION 1.8.0_412-b11

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \
    fi; \
    curl -fSL -o bisheng-jdk.tar.gz https://mirrors.huaweicloud.com/kunpeng/archive/compiler/bisheng_jdk/bisheng-jdk-${VERSION}-linux-${BUILDARCH}.tar.gz; \
    mkdir -p ${JAVA_HOME}; \
    tar -xvf bisheng-jdk.tar.gz -C ${JAVA_HOME} --strip-components=1; \
    rm -f bisheng-jdk.tar.gz
  
RUN rm -rf "$JAVA_HOME/jre/lib/security/cacerts"; \
    ln -sT /etc/pki/ca-trust/extracted/java/cacerts "$JAVA_HOME/jre/lib/security/cacerts"; \
    alternatives --install /usr/bin/java java "$JAVA_HOME/bin/java" 20000; \
    alternatives --install /usr/bin/javac javac "$JAVA_HOME/bin/javac" 20000; \
    javac -version; \
    java -version

CMD ["java"]
