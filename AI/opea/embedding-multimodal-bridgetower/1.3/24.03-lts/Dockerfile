# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
ARG BASE=openeuler/python:3.10.17-oe2403lts
ARG VERSION=v1.3

FROM $BASE

# Set this to "cpu" or "gpu" or etc
ARG ARCH="cpu"

RUN yum update -y && \
    yum install -y \
        git \
        shadow \
        curl && \
    yum clean all

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/


# Set environment variables
ENV LANG=en_US.UTF-8
ENV PYTHONPATH=/home/user:/usr/lib/habanalabs/:/optimum-habana

ARG VERSION
ARG GENAICOMPS_REPO=https://github.com/opea-project/GenAIComps.git
RUN git clone -b $VERSION $GENAICOMPS_REPO && \
    mkdir -p /home/user && \
    cp -r GenAIComps/comps /home/user/comps && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    if [ ${ARCH} = "cpu" ]; then \
      pip install --no-cache-dir --extra-index-url https://download.pytorch.org/whl/cpu -r /home/user/comps/third_parties/bridgetower/src/requirements.txt; \
    else \
      pip install --no-cache-dir -r /home/user/comps/third_parties/bridgetower/src/requirements.txt; \
    fi
    

ENV PYTHONPATH=$PYTHONPATH:/home/user
USER user
ARG EMBEDDER_PORT=8080
ENV PORT=$EMBEDDER_PORT

WORKDIR /home/user/comps/third_parties/bridgetower/src/

ENTRYPOINT ["python", "bridgetower_server.py", "--device", "cpu"]