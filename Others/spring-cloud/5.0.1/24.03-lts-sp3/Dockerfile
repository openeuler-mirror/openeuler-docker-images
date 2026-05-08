ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE} as BUILDER
ARG VERSION=5.0.1
ARG TARGETARCH
ARG JDK_VERSION=17.0.19_10

RUN dnf update -y \
    && dnf install -y git maven \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN dnf install -y wget
RUN if [ "$TARGETARCH" = "amd64" ]; then \
      JDKARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      JDKARCH="aarch64"; \
    fi \
    && cd / \
    && wget https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jdk/${JDKARCH}/linux/OpenJDK17U-jdk_${JDKARCH}_linux_hotspot_${JDK_VERSION}.tar.gz \
    && tar -zxvf OpenJDK17U-jdk_${JDKARCH}_linux_hotspot_${JDK_VERSION}.tar.gz \
    && rm -f OpenJDK17U-jdk_${JDKARCH}_linux_hotspot_${JDK_VERSION}.tar.gz

ENV JAVA_HOME=/jdk-${JDK_VERSION}
ENV PATH=${JAVA_HOME}/bin:$PATH

RUN git clone -b v${VERSION} --depth 1 https://github.com/spring-cloud/spring-cloud-commons \
    && cd spring-cloud-commons \
    && ./mvnw clean install -Dgpg.skip=true

CMD ["bash"]