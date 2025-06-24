ARG BASE=openeuler/openeuler:24.03-lts-sp1

FROM ${BASE} as BUILDER
ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=3.3.4
ARG JDK_VERSION=17.0.15_6

RUN dnf install -y wget unzip gettext \
    && dnf clean all \
    && rm -rf /var/cache/dnf

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

ARG NACOS_VERSION=3.0.0
RUN cd /home \
    && wget https://github.com/alibaba/nacos/releases/download/${NACOS_VERSION}/nacos-server-${NACOS_VERSION}.zip \
    && unzip nacos-server-${NACOS_VERSION}.zip \
    && rm -f nacos-server-${NACOS_VERSION}.zip

COPY application.properties /home/nacos/conf/application.properties

RUN cd /home \
    && wget https://dubbo-demo.oss-cn-hangzhou.aliyuncs.com/quickstart/dubbo-quickstart.zip \
    && unzip dubbo-quickstart.zip \
    && rm -f dubbo-quickstart.zip \
    && rm -f pom.xml

WORKDIR /home/dubbo-quickstart

ENV DUBBO_VERSION=${VERSION}

COPY pom.xml.template pom.xml.template

COPY entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh

EXPOSE 50051

ENTRYPOINT ["./entrypoint.sh"]