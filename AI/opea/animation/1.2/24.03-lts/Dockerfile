# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

ARG BASE=openeuler/python:3.11.13-oe2403lts
ARG VERSION=v1.2

# Use a base image
FROM $BASE

ARG VERSION

RUN yum update -y && \
    yum install -y \
    shadow \
    git && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/
USER user

ENV LANG=C.UTF-8
ARG ARCH=cpu

WORKDIR /home/user

ARG GENAICOMPS_REPO=https://github.com/opea-project/GenAIComps.git
RUN git clone -b $VERSION $GENAICOMPS_REPO && \
    cp -r GenAIComps/comps /home/user/comps && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /home/user/comps/animation/src/requirements.txt ;

ENV PYTHONPATH=$PYTHONPATH:/home/user

WORKDIR /home/user/comps/animation/src

ENTRYPOINT ["python3", "opea_animation_microservice.py"]