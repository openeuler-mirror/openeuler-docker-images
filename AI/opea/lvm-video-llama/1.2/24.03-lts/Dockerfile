# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

ARG BASE=openeuler/python:3.9.9-oe2403lts
ARG VERSION=v1.2

FROM $BASE

ARG VERSION

ENV LANG=C.UTF-8

RUN yum update -y && \
    yum install -y \
    shadow \
    tar \
    git \
    wget \
    curl && \ 
    yum clean all && \
    rm -rf /var/cache/yum

ARG GITLFS_URL=https://github.com/git-lfs/git-lfs/releases/download/v3.7.0/git-lfs-linux-amd64-v3.7.0.tar.gz

RUN wget $GITLFS_URL -O git-lfs.tar.gz && \
    tar -xvf git-lfs.tar.gz && \
    rm -rf git-lfs.tar.gz && \
    mv git-lfs-* /usr/local/git-lfs && \
    /usr/local/git-lfs/install.sh && \
    git lfs install

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user:user /home/user/
RUN mkdir /home/user/model && chown user:user -R /home/user/model

USER user

WORKDIR /home/user

ARG GENAICOMPS_REPO=https://github.com/opea-project/GenAIComps.git
RUN git clone -b $VERSION $GENAICOMPS_REPO && \
    cp -r GenAIComps/comps /home/user/comps && \
    rm -rf GenAIComps

WORKDIR /home/user/comps/lvms/src/integrations/dependency/video-llama/

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /home/user/comps/lvms/src/integrations/dependency/video-llama/requirements.txt

ARG VIDEO_LLAMA_REPO=https://github.com/DAMO-NLP-SG/Video-LLaMA.git
ARG VIDEO_LLAMA_COMMIT=0adb19e
RUN tar -xvf video-llama.patch.tar && \
    git clone ${VIDEO_LLAMA_REPO} Video-LLaMA && \
    cd Video-LLaMA && git checkout ${VIDEO_LLAMA_COMMIT} && \
    git apply --whitespace=fix ../video-llama.patch && \
    mv video_llama ../ && \
    cd ../ && rm -rf Video-LLaMA


ENV PYTHONPATH=/home/user


ENTRYPOINT ["bash", "start.sh"]