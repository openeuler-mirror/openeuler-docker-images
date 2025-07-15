ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=1.9.0

RUN dnf update -y \
    && dnf install -y python3-pip \
    && dnf clean all \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/dnf

RUN pip3 install mne==${VERSION}
