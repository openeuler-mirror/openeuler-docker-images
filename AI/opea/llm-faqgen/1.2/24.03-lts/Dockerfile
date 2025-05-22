# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

# Use a base image
FROM openeuler/openeuler:24.03-lts

# Set this to "cpu" or "gpu" or etc
ARG ARCH="cpu"

RUN yum update -y && \
    yum install -y \
    mesa-libGL \
    jemalloc-devel \
    python python-pip \
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
    if [ ${ARCH} = "cpu" ]; then \
      pip install --no-cache-dir --extra-index-url https://download.pytorch.org/whl/cpu -r /home/user/comps/llms/src/faq-generation/requirements.txt; \
    else \
      pip install --no-cache-dir -r /home/user/comps/llms/src/faq-generation/requirements.txt; \
    fi

ENV PYTHONPATH=$PYTHONPATH:/home/user

USER user

WORKDIR /home/user/comps/llms/src/faq-generation

ENTRYPOINT ["bash", "entrypoint.sh"]