ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=4.1.7

RUN dnf update -y && dnf install -y wget java-17-openjdk util-linux && dnf clean all
ENV JAVA_HOME=/usr/lib/jvm/jre-17-openjdk

WORKDIR /opt/starrocks

RUN wget -O starrocks.tar.gz https://releases.starrocks.io/starrocks/StarRocks-${VERSION}-centos-${TARGETARCH}.tar.gz && \
    tar -xzf starrocks.tar.gz --strip-components=1 && \
    rm -f starrocks.tar.gz

EXPOSE 8030 8040 9030

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--daemon"]
