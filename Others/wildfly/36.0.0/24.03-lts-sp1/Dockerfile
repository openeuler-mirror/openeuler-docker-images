ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=36.0.0
ARG JDK_VERSION=17.0.15_6
ARG WILDFLY_HOME=/opt/wildfly

RUN dnf install -y wget shadow-utils \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

USER root

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \
    fi \
    && cd / \
    && yum install -y wget \
    && wget https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jdk/${BUILDARCH}/linux/OpenJDK17U-jdk_${BUILDARCH}_linux_hotspot_${JDK_VERSION}.tar.gz \
    && tar -zxvf OpenJDK17U-jdk_${BUILDARCH}_linux_hotspot_${JDK_VERSION}.tar.gz \
    && rm -f OpenJDK17U-jdk_${BUILDARCH}_linux_hotspot_${JDK_VERSION}.tar.gz

ENV JAVA_HOME=/jdk-17.0.15+6
ENV PATH=${JAVA_HOME}/bin:$PATH

RUN mkdir -p ${WILDFLY_HOME} \
    && groupadd -r wildfly -g 1000 \
    && useradd -u 1000 -r -g wildfly -d ${WILDFLY_HOME} wildfly \
    && chown -R wildfly:wildfly ${WILDFLY_HOME}

USER wildfly

WORKDIR ${WILDFLY_HOME}

RUN wget https://github.com/wildfly/wildfly/releases/download/${VERSION}.Final/wildfly-${VERSION}.Final.tar.gz \
    && tar -zxvf wildfly-${VERSION}.Final.tar.gz --strip-components=1 \
    && rm -f wildfly-${VERSION}.Final.tar.gz

ENV LAUNCH_JBOSS_IN_BACKGROUND true

EXPOSE 8080

CMD ["./bin/standalone.sh", "-b", "0.0.0.0"]