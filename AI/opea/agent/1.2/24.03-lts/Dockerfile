# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

ARG BASE=openeuler/python:3.11.13-oe2403lts
ARG VERSION=v1.2 

FROM $BASE

ARG VERSION

ENV LANG=C.UTF-8
ARG ARCH=cpu

RUN yum update -y && \
    yum install -y \
    shadow \
    gcc g++ make cmake \
    mesa-libGL \
    jemalloc-devel \
    git && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

USER user
WORKDIR /home/user

ARG GENAICOMPS_REPO=https://github.com/opea-project/GenAIComps.git
RUN git clone -b $VERSION $GENAICOMPS_REPO && \
    cp -r GenAIComps/comps /home/user/comps && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    if [ ${ARCH} = "cpu" ]; then \
        pip install --no-cache-dir --extra-index-url https://download.pytorch.org/whl/cpu -r /home/user/comps/agent/src/requirements.txt; \
    else \
        pip install --no-cache-dir -r /home/user/comps/agent/src/requirements.txt; \
    fi

ENV PYTHONPATH=/home/user

USER root

RUN mkdir -p /home/user/comps/agent/src/status && chown -R user /home/user/comps/agent/src/status

USER user

WORKDIR /home/user/comps/agent/src/

ENTRYPOINT ["python", "agent.py"]