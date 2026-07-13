ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=3.1.3

ENV LANG=C.UTF-8 \
    DEEPMD_HOME=/opt/deepmd-kit

RUN dnf -y update && \
    dnf -y install --nodocs --setopt=install_weak_deps=False \
        python3 python3-pip && \
    dnf clean all && rm -rf /var/cache/dnf

RUN pip3 install --upgrade pip && \
    pip3 install torch numpy && \
    pip3 install deepmd-kit==${VERSION}

WORKDIR ${DEEPMD_HOME}

LABEL org.opencontainers.image.title="deepmd-kit" \
    org.opencontainers.image.version="${VERSION}"