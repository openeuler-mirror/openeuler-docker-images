ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=4.1.1

RUN dnf update -y && dnf install -y wget java-11-openjdk && dnf clean all

WORKDIR /opt/starrocks

RUN wget -O starrocks.tar.gz https://releases.starrocks.io/starrocks/StarRocks-${VERSION}-centos-${TARGETARCH}.tar.gz && \
    tar -xzf starrocks.tar.gz --strip-components=1 && \
    rm -f starrocks.tar.gz

EXPOSE 8030 8040 9030

ENTRYPOINT ["/opt/starrocks/fe/bin/start_fe.sh"]
CMD ["--daemon"]
