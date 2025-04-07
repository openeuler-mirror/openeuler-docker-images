ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH

RUN yum update -y && \
    yum install -y maven java-1.8.0-openjdk java-1.8.0-openjdk-devel jq && \
    yum clean all && \
    rm -rf /var/cache/yum


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

