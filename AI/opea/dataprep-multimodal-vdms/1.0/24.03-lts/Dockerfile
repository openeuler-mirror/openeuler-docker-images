
# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

ENV LANG=C.UTF-8

ARG ARCH="cpu"

RUN yum update -y && \
    yum install -y  \
    --setopt=install_weak_deps=False \
    python-pip python \
    shadow-utils \
    mesa-libGL \
    jemalloc-devel \
    gcc gcc-g++ make \
    git \
    cairo-devel \
    vim

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

USER user

WORKDIR /home/user
RUN git clone https://github.com/opea-project/GenAIComps.git && cd GenAIComps && git checkout v1.0

RUN cp -r GenAIComps/comps . && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    if [ ${ARCH} = "cpu" ]; then pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu; fi && \
    pip install --no-cache-dir -r /home/user/comps/dataprep/vdms/multimodal_langchain/requirements.txt

ENV PYTHONPATH=/home/user

USER root

RUN mkdir -p /home/user/comps/dataprep/vdms/multimodal_langchain/uploaded_files && chown -R user /home/user/comps/dataprep/vdms/multimodal_langchain

USER user

WORKDIR /home/user/comps/dataprep/vdms/multimodal_langchain

ENTRYPOINT ["python", "ingest_videos.py"]