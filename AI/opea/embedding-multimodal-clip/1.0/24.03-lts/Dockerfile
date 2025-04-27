# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

ARG ARCH="cpu"

RUN yum update -y && \
    yum install -y  \
    --setopt=install_weak_deps=False \
    python-pip python \
    shadow-utils \
    mesa-libGL \
    jemalloc-devel \
    git \
    vim

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

USER user

WORKDIR /home/user
RUN git clone https://github.com/opea-project/GenAIComps.git && cd GenAIComps && git checkout v1.0

RUN cp -r GenAIComps/comps . && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip && \
    if [ ${ARCH} = "cpu" ]; then pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu; fi && \
    pip install --no-cache-dir -r /home/user/comps/embeddings/multimodal_clip/requirements.txt

ENV PYTHONPATH=$PYTHONPATH:/home/user

WORKDIR /home/user/comps/embeddings/multimodal_clip

ENTRYPOINT ["python", "embedding_multimodal.py"]
