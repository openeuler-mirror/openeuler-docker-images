ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=11.0.7
ARG TARGETARCH
ARG BUILDARCH
ARG JDK_VERSION=17.0.12

RUN dnf update -y \
    && dnf install -y git wget ant \
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

WORKDIR /opt

RUN git clone -b ${VERSION} --depth 1 https://github.com/apache/tomcat.git \
    && cd tomcat \
    && ant

WORKDIR /opt/tomcat/output/build/bin

EXPOSE 8080

CMD ["./catalina.sh", "run"]