ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=0.24.0

RUN dnf install -y python3-pip && dnf clean all

RUN pip install --no-cache-dir pysam==${VERSION}

USER root

