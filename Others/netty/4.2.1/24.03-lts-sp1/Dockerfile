ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=4.2.1
ARG JDK_VERSION=17.0.12

RUN dnf update -y \
    && dnf install -y wget maven gettext \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \
    fi \
    && cd / \
    && wget https://download.oracle.com/java/17/archive/jdk-${JDK_VERSION}_linux-${BUILDARCH}_bin.tar.gz \
    && tar -zxvf jdk-${JDK_VERSION}_linux-${BUILDARCH}_bin.tar.gz \
    && rm -f jdk-${JDK_VERSION}_linux-${BUILDARCH}_bin.tar.gz

ENV JAVA_HOME=/jdk-17.0.12
ENV PATH=/jdk-17.0.12/bin:$PATH

WORKDIR /opt/netty

COPY NettyDemo.java src/main/java/demo/NettyDemo.java
COPY pom.xml.template pom.xml.template

ENV NETTY_VERSION=${VERSION}.Final

RUN envsubst < pom.xml.template > pom.xml \
    && mvn clean package -Dfile.encoding=UTF-8

CMD ["java", "-cp", "target/netty-demo-1.0-SNAPSHOT.jar", "demo.NettyDemo"]
