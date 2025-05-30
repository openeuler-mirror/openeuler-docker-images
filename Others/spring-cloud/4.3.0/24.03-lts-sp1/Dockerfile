ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG VERSION=4.3.0
ARG TARGETARCH
ARG BUILDARCH
ARG JDK_VERSION=17.0.15_6

RUN dnf update -y \
    && dnf install -y git maven \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN dnf install -y wget
RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \
    fi \
    && cd / \
    && wget https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jdk/${BUILDARCH}/linux/OpenJDK17U-jdk_${BUILDARCH}_linux_hotspot_${JDK_VERSION}.tar.gz \
    && tar -zxvf OpenJDK17U-jdk_${BUILDARCH}_linux_hotspot_${JDK_VERSION}.tar.gz \
    && rm -f OpenJDK17U-jdk_${BUILDARCH}_linux_hotspot_${JDK_VERSION}.tar.gz

ENV JAVA_HOME=/jdk-17.0.15+6
ENV PATH=${JAVA_HOME}/bin:$PATH

RUN git clone -b v${VERSION} --depth 1 https://github.com/spring-cloud/spring-cloud-commons \
    && cd spring-cloud-commons \
    && ./mvnw clean install -Dgpg.skip=true

CMD ["bash"]