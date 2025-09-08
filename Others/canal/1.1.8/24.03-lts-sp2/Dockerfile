ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG VERSION=1.1.8

RUN yum update -y && \
    yum install -y java-1.8.0-openjdk wget file hostname && \
    yum clean all

RUN mkdir -p /opt/canal && \
    wget https://github.com/alibaba/canal/releases/download/canal-${VERSION}/canal.deployer-${VERSION}.tar.gz && \
    tar zxvf canal.deployer-${VERSION}.tar.gz -C /opt/canal && \
    rm -f canal.deployer-${VERSION}.tar.gz

COPY instance.properties /opt/canal/conf/example/instance.properties

WORKDIR /opt/canal

EXPOSE 11110 11111 11112

COPY startup.sh /opt/canal/bin/startup.sh

RUN chmod +x /opt/canal/bin/startup.sh

ENTRYPOINT /opt/canal/bin/startup.sh