# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

ARG BASE=openeuler/python:3.11.13-oe2403lts
ARG VERSION=v1.2

# Stage 1: base setup used by other stages
FROM $BASE AS base

ARG VERSION

# get security updates
RUN yum update -y && \
    yum install -y \
    shadow && \
    yum clean all && \
    rm -rf /var/lib/yum

ENV HOME=/home/user

RUN useradd -m -s /bin/bash user && \
    mkdir -p $HOME && \
    chown -R user $HOME

WORKDIR $HOME


# Stage 2: latest GenAIComps sources
FROM base AS git

ARG VERSION

RUN yum update -y && \
    yum install -y git && \
    yum clean all && \
    rm -rf /var/cache/yum

ARG GENAICOMPS_REPO=https://github.com/opea-project/GenAIComps.git
RUN git clone -b $VERSION $GENAICOMPS_REPO

ARG GENAIEXAMPLES_REPO=https://github.com/opea-project/GenAIExamples.git
RUN git clone -b $VERSION $GENAIEXAMPLES_REPO

# Stage 3: common layer shared by services using GenAIComps
FROM base AS comps-base

# copy just relevant parts
COPY --from=git $HOME/GenAIComps/comps $HOME/GenAIComps/comps
COPY --from=git $HOME/GenAIComps/*.* $HOME/GenAIComps/LICENSE $HOME/GenAIComps/
COPY --from=git $HOME/GenAIExamples/FaqGen/faqgen.py $HOME/faqgen.py

WORKDIR $HOME/GenAIComps
RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r $HOME/GenAIComps/requirements.txt
WORKDIR $HOME

ENV PYTHONPATH=$PYTHONPATH:$HOME/GenAIComps

USER user

ENTRYPOINT ["python", "faqgen.py"]