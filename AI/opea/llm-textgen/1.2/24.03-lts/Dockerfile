# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

RUN yum update -y && \
    yum install -y \
        python python-pip \
        mesa-libGL \
        jemalloc-devel \
        git

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

USER user
WORKDIR /home/user/

RUN git clone -b v1.2 https://github.com/opea-project/GenAIComps.git && \
    cp -r GenAIComps/comps /home/user/comps && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r /home/user/comps/llms/src/text-generation/requirements.txt

ENV PYTHONPATH=$PYTHONPATH:/home/user

WORKDIR /home/user/comps/llms/src/text-generation

ENTRYPOINT ["bash", "entrypoint.sh"]