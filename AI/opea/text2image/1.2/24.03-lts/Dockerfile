# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

ARG BASE=openeuler/python:3.11.13-oe2403lts
ARG VERSION=v1.2

FROM $BASE

ARG VERSION

RUN yum update -y && \
    yum install -y \
    git && \
    yum clean all && \
    rm -rf /var/cache/yum

# Set environment variables
ENV LANG=en_US.UTF-8

ARG ARCH="cpu"

WORKDIR /home

ARG GENAICOMPS_REPO=https://github.com/opea-project/GenAIComps.git
RUN git clone -b $VERSION $GENAICOMPS_REPO && \
    cp -r GenAIComps/comps /home/comps && \
    rm -rf GenAIComps


RUN pip install --no-cache-dir --upgrade pip setuptools && \
    if [ ${ARCH} = "cpu" ]; then \
      pip install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cpu; fi && \
    pip install --no-cache-dir -r /home/comps/text2image/src/requirements.txt

ENV PYTHONPATH=$PYTHONPATH:/home

WORKDIR /home/comps/text2image/src

RUN echo python opea_text2image_microservice.py --bf16 >> run.sh

CMD bash run.sh