# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

ARG ARCH="cpu"  # Set this to "cpu" or "gpu"

RUN yum update -y && \
    yum install -y \
    python python-pip \
    mesa-libGL \
    jemalloc-devel \
    curl \
    git

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

USER user

WORKDIR /home/user

RUN git clone -b v1.2 https://github.com/opea-project/GenAIComps.git

RUN cp -r GenAIComps/comps /home/user/comps && \
    rm -rf GenAIComps
    
RUN pip install --no-cache-dir --upgrade pip setuptools && \
    if [ ${ARCH} = "cpu" ]; then \
      pip install --no-cache-dir --extra-index-url https://download.pytorch.org/whl/cpu -r /home/user/comps/web_retrievers/src/requirements.txt; \
    else \
      pip install --no-cache-dir -r /home/user/comps/web_retrievers/src/requirements.txt; \
    fi

ENV PYTHONPATH=$PYTHONPATH:/home/user

WORKDIR /home/user/comps/web_retrievers/src

ENTRYPOINT ["python", "opea_web_retrievers_microservice.py"]