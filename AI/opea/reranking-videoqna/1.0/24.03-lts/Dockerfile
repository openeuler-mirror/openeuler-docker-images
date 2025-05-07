
# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

ENV LANG=C.UTF-8

RUN yum update -y && \
    yum install -y  \
    --setopt=install_weak_deps=False \
    python-pip python \
    shadow-utils \
    git

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

USER user

WORKDIR /home/user

RUN git clone https://github.com/opea-project/GenAIComps.git && cd GenAIComps && git checkout v1.0

RUN cp -r GenAIComps/comps . && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /home/user/comps/reranks/videoqna/requirements.txt

ENV PYTHONPATH=$PYTHONPATH:/home/user

WORKDIR /home/user/comps/reranks/videoqna

ENTRYPOINT ["python", "local_reranking.py"]