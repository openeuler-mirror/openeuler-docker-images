ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG TRAIN_VERSION=2026.0.0
ARG MAVEN_VERSION=3.9.16
ARG MAVEN_DL_URL=https://mirrors.aliyun.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
ARG MAVEN_CENTRAL_MIRROR=""
ARG TARGETARCH

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN dnf install -y --setopt=install_weak_deps=False \
        java-17-openjdk-devel \
        curl tar gzip && \
    dnf clean all && \
    curl -fSL --connect-timeout 30 --retry 3 \
        -o /tmp/maven.tar.gz "${MAVEN_DL_URL}" && \
    tar -xzf /tmp/maven.tar.gz -C /opt && \
    ln -s "/opt/apache-maven-${MAVEN_VERSION}/bin/mvn" /usr/local/bin/mvn && \
    rm -f /tmp/maven.tar.gz

# Optional Maven Central mirror (e.g. https://maven.aliyun.com/repository/public)
RUN if [ -n "${MAVEN_CENTRAL_MIRROR}" ]; then \
        mkdir -p /root/.m2 && \
        printf '<settings><mirrors><mirror><id>mirror-central</id><mirrorOf>central</mirrorOf><url>%s</url></mirror></mirrors></settings>' \
            "${MAVEN_CENTRAL_MIRROR}" > /root/.m2/settings.xml; \
    fi

WORKDIR /build
COPY pom.xml ./
COPY src ./src

RUN mvn -B --no-transfer-progress -DskipTests package

FROM ${BASE}

ARG COMPONENT_VERSION=5.1.0
ARG TRAIN_VERSION=2026.0.0
ARG JDK_RUNTIME_PKG=java-17-openjdk-headless

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN dnf install -y --setopt=install_weak_deps=False "${JDK_RUNTIME_PKG}" && \
    dnf clean all

WORKDIR /app
COPY --from=builder /build/target/app.jar /app/app.jar
COPY default-config/application.yml /app/config/application.yml
RUN echo "spring-cloud-vault ${COMPONENT_VERSION} (release-train ${TRAIN_VERSION})" > /app/IMAGE_VERSION

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
