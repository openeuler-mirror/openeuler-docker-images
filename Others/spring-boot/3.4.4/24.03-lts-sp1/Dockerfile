ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=3.4.4
ARG JDK_VERSION=17.0.15_6
ARG MAVEN_VERSION=3.8.1

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \
    fi \
    && cd / \
    && yum install -y wget \
    && wget https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jdk/${BUILDARCH}/linux/OpenJDK17U-jdk_${BUILDARCH}_linux_hotspot_${JDK_VERSION}.tar.gz \
    && tar -zxvf OpenJDK17U-jdk_${BUILDARCH}_linux_hotspot_${JDK_VERSION}.tar.gz \
    && wget https://repo.huaweicloud.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar -zxvf apache-maven-${MAVEN_VERSION}-bin.tar.gz

ENV JAVA_HOME=/jdk-17.0.15+6
ENV PATH=${JAVA_HOME}/bin:$PATH

ENV MAVEN_HOME=/apache-maven-${MAVEN_VERSION}
ENV PATH=${MAVEN_HOME}/bin:$PATH

COPY Application.java /spring-boot/src/main/java/com/spring/boot/Application.java
COPY pom.xml.template /spring-boot/pom.xml.template

ENV SPRING_BOOT_VERSION=${VERSION}

RUN dnf install -y gettext \
    && cd /spring-boot \
    && envsubst < pom.xml.template > pom.xml \
    && mvn clean install package -Dmaven.test.skip


FROM ${BASE}
ARG TARGETARCH
ARG BUILDARCH
ARG JRE_VERSION=17.0.15_6

RUN yum update -y \
    && yum install -y wget

ENV WORKSPACE=/home/spring-boot

WORKDIR ${WORKSPACE}

COPY --chown=spring-boot --from=Builder /spring-boot/target ${WORKSPACE}/target

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \
    fi \
    && wget https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jre/${BUILDARCH}/linux/OpenJDK17U-jre_${BUILDARCH}_linux_hotspot_${JRE_VERSION}.tar.gz \
    && tar -zxvf OpenJDK17U-jre_${BUILDARCH}_linux_hotspot_${JRE_VERSION}.tar.gz \
    && rm OpenJDK17U-jre_${BUILDARCH}_linux_hotspot_${JRE_VERSION}.tar.gz

ENV JAVA_HOME=${WORKSPACE}/jdk-17.0.15+6-jre
ENV PATH=${JAVA_HOME}/bin:$PATH
ENV LANG="C.UTF-8"

EXPOSE 8080

CMD java -jar ${WORKSPACE}/target/demo-1.0.jar