ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=1.12.0

RUN yum install -y python3-pip java-1.8.0-openjdk-devel && \
    yum clean all && \
    pip install avro==${VERSION}
