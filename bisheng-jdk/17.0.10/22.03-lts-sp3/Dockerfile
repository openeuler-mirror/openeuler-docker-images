ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=17.0.10

RUN yum update -y; \
    yum install -y ca-certificates p11-kit; \
    yum clean all

ENV JAVA_HOME /usr/lib/jvm/java-openjdk-${VERSION}
ENV PATH $JAVA_HOME/bin:$PATH
ENV LANG C.UTF-8
ENV JAVA_VERSION 17.0.10+11

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \
    fi; \
    curl -fSL -o bisheng-jdk.tar.gz https://mirrors.huaweicloud.com/kunpeng/archive/compiler/bisheng_jdk/bisheng-jdk-${VERSION}-linux-${BUILDARCH}.tar.gz; \
    mkdir -p ${JAVA_HOME}; \
    tar -xvf bisheng-jdk.tar.gz -C ${JAVA_HOME} --strip-components=1; \
    rm -f bisheng-jdk.tar.gz

RUN update-ca-trust; \
    alternatives --install /usr/bin/java java "$JAVA_HOME/bin/java" 20000; \
    alternatives --install /usr/bin/javac javac "$JAVA_HOME/bin/javac" 20000; \
    alternatives --install /usr/bin/jshell jshell "$JAVA_HOME/bin/jshell" 20000; \
    java -Xshare:dump; \
    # basic smoke test
    fileEncoding="$(echo 'System.out.println(System.getProperty("file.encoding"))' | jshell -s -)"; [ "$fileEncoding" = 'UTF-8' ]; rm -rf ~/.java; \
    javac --version; \
    java --version

CMD ["jshell"]
