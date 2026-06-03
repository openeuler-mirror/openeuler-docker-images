ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE} AS builder

ARG VERSION=0.6.3
ARG MAVEN_VERSION=3.9.9

RUN dnf install -y \
      git gcc gcc-c++ make cmake \
      java-1.8.0-openjdk-devel curl && \
    dnf clean all

RUN curl -fSL -o apache-maven.tar.gz https://repo.huaweicloud.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mkdir -p /usr/local/maven && \
    tar -zxf apache-maven.tar.gz -C /usr/local/maven --strip-components=1 && \
    rm -rf apache-maven.tar.gz
ENV PATH=$PATH:/usr/local/maven/bin

RUN git clone --depth 1 --branch v${VERSION} https://github.com/apache/celeborn.git /opt/celeborn-src

WORKDIR /opt/celeborn-src
RUN ./build/make-distribution.sh -DskipTests \
      -Pspark-3.5 && \
    tar -xzf apache-celeborn-${VERSION}-bin.tgz -C /opt/ && \
    ln -s /opt/apache-celeborn-${VERSION}-bin /opt/celeborn

FROM ${BASE}

ARG VERSION=0.6.3

RUN dnf install -y \
      java-1.8.0-openjdk \
      shadow && \
    dnf clean all

RUN groupadd -r celeborn && useradd -r -g celeborn celeborn

COPY --from=builder /opt/apache-celeborn-${VERSION}-bin /opt/apache-celeborn-${VERSION}-bin
RUN ln -s /opt/apache-celeborn-${VERSION}-bin /opt/celeborn

ENV CELEBORN_HOME=/opt/celeborn
ENV PATH=$PATH:/opt/celeborn/sbin

EXPOSE 9097 9098 9096

USER celeborn
WORKDIR /opt/celeborn
