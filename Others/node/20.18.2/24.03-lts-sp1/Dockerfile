ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

RUN yum update -y && \
    yum install -y nodejs && \
    yum clean all && \
    rm -rf /var/cache/yum

WORKDIR /tmp

CMD [ "node" ]