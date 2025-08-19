ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE} as BUILDER
ARG VERSION=3.3.5

RUN dnf install -y wget unzip gettext java-17-openjdk java-17-openjdk-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

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