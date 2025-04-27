# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/python:3.10.17-oe2403lts

ENV LANG=C.UTF-8

RUN yum update -y && \
    yum install -y  \
    --setopt=install_weak_deps=False \
    shadow-utils \
    git \
    wget

RUN mkdir -p /tmp/git-lfs/git-lfs && \
    wget -O /tmp/git-lfs/git-lfs-3.6.1.tar.gz https://github.com/git-lfs/git-lfs/releases/download/v3.6.1/git-lfs-linux-amd64-v3.6.1.tar.gz && \
    tar xvf /tmp/git-lfs/git-lfs-3.6.1.tar.gz -C  /tmp/git-lfs/git-lfs --strip-components 1 && \
    ./tmp/git-lfs/git-lfs/install.sh && \
    rm -rf /tmp/git-lfs
    
RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user:user /home/user/

RUN mkdir /home/user/model && chown user:user -R /home/user/model

USER user

ENV PATH=/usr/local/python3.10/bin:$PATH

WORKDIR /home/user
RUN git clone https://github.com/opea-project/GenAIComps.git && cd GenAIComps && git checkout v1.0

RUN cp -r GenAIComps/comps . && \
    rm -rf GenAIComps

WORKDIR /home/user/comps/lvms/video-llama/dependency

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /home/user/comps/lvms/video-llama/dependency/requirements.txt

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