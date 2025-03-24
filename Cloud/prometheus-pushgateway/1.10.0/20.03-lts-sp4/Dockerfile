ARG BASE=openeuler/openeuler:20.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.10.0
    
RUN yum update -y && yum install -y wget && yum clean all && \
    wget -O pushgateway.tar.gz https://github.com/prometheus/pushgateway/releases/download/v${VERSION}/pushgateway-${VERSION}.linux-${TARGETARCH}.tar.gz && \
    mkdir /pushgateway && tar -zxvf pushgateway.tar.gz -C /pushgateway --strip-components 1 && \
    mv /pushgateway/pushgateway /bin/pushgateway && \
    rm -rf pushgateway.tar.gz /pushgateway/

RUN mkdir -p /pushgateway && \
    groupadd -r pushgateway && useradd -r -g pushgateway pushgateway && \
    chown pushgateway:pushgateway /pushgateway /bin/pushgateway

WORKDIR /pushgateway
USER pushgateway
EXPOSE 9091
ENTRYPOINT [ "/bin/pushgateway" ]
