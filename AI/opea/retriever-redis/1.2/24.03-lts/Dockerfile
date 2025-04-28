# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

ARG ARCH="cpu"

RUN yum update -y && \
    yum install -y \
    mesa-libGL \
    jemalloc-devel \
    python python-pip \
    cairo \
    glib2 \
    vim \
    git

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

WORKDIR /home/user/

RUN git clone https://github.com/opea-project/GenAIComps.git && cd GenAIComps && git checkout v1.2

RUN cp -r GenAIComps/comps . && \
    rm -rf GenAIComps

USER user

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    if [ ${ARCH} = "cpu" ]; then \
        PIP_EXTRA_INDEX_URL="--extra-index-url https://download.pytorch.org/whl/cpu"; \
    else \
        PIP_EXTRA_INDEX_URL=""; \
    fi && \
    pip install --no-cache-dir torch torchvision ${PIP_EXTRA_INDEX_URL} && \
    pip install --no-cache-dir ${PIP_EXTRA_INDEX_URL} -r /home/user/comps/retrievers/src/requirements.txt && \
    pip install opentelemetry-api==1.27.0 opentelemetry-exporter-otlp==1.27.0 opentelemetry-sdk==1.27.0
    
RUN pip install --no-cache-dir protobuf && \
    pip3 install --no-cache-dir pymilvus==2.5.0

ENV PYTHONPATH=/usr/bin/python:/home/user

WORKDIR /home/user/comps/retrievers/src

ENTRYPOINT ["python", "opea_retrievers_microservice.py"]
