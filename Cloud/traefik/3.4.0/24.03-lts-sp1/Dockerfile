ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=3.4.0

RUN yum -y update && \
    yum -y install wget && \
    yum clean all

RUN wget -O /tmp/traefik.tar.gz https://github.com/traefik/traefik/releases/download/v${VERSION}/traefik_v${VERSION}_linux_${TARGETARCH}.tar.gz && \
    tar -zxvf /tmp/traefik.tar.gz -C /usr/bin traefik && \
    chmod +x /usr/bin/traefik && \
    rm -rf /tmp/traefik.tar.gz
	
COPY entrypoint.sh /
EXPOSE 80
ENTRYPOINT ["bash", "/entrypoint.sh"]
CMD ["traefik"]
