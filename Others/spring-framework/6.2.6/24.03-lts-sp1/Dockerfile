ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER

ARG TARGETARCH
ARG VERSION=6.2.6
ARG JDK_VERSION=17.0.15_6

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

WORKDIR /home/spring-framework
COPY example src/main/java/com/example
COPY pom.xml.template pom.xml.template

ENV SPRING_VERSION=${VERSION}

RUN dnf install -y gettext maven \
    && envsubst < pom.xml.template > pom.xml \
    && mvn clean compile dependency:build-classpath -Dmdep.outputFile=target/classpath.txt

CMD CLASS_PATH="target/classes:$(cat target/classpath.txt)" && \
    java -cp "$CLASS_PATH" com.example.MainApp