ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

RUN yum update -y && \
    yum install -y python3-pip python3-devel jq && \
    yum clean all && \
    rm -rf /var/cache/yum

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]