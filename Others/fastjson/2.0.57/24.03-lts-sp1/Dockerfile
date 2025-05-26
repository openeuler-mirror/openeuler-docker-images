ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=2.0.57
ARG JDK_VERSION=17.0.15_6

RUN dnf install -y maven gettext wget \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

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
ENV LANG="C.UTF-8"

WORKDIR /home/fastjson
COPY Fastjson2Demo.java src/main/java/com/example/Fastjson2Demo.java
COPY pom.xml.template pom.xml.template

ENV FAST_JSON_VERSION=${VERSION}

RUN envsubst < pom.xml.template > pom.xml \
    && mvn clean compile -Dfile.encoding=UTF-8

CMD mvn exec:java -Dexec.mainClass="com.example.Fastjson2Demo"