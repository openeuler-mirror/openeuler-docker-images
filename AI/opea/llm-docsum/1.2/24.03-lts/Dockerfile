# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

ARG ARCH="cpu"

RUN yum update -y && \
    yum install -y \
    python-pip python \
    mesa-libGL \
    jemalloc-devel \
    git

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

USER user

WORKDIR /home/user/

RUN git clone -b v1.2 https://github.com/opea-project/GenAIComps.git

RUN cp -r GenAIComps/comps . && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    if [ ${ARCH} = "cpu" ]; then pip install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cpu; fi && \
    pip install --no-cache-dir -r /home/user/comps/llms/src/doc-summarization/requirements.txt

ENV PYTHONPATH=$PYTHONPATH:/home/user

WORKDIR /home/user/comps/llms/src/doc-summarization

ENTRYPOINT ["bash", "entrypoint.sh"]