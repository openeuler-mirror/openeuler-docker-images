ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

RUN yum update -y && \
    yum install -y python3-pip python3-devel jq && \
    yum clean all && \
    rm -rf /var/cache/yum

# Dependencies required for installing horovod
RUN dnf install -y openmpi openmpi-devel gcc gcc-c++ cmake make git && \
    yum clean all && \
    rm -rf /var/cache/yum

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]