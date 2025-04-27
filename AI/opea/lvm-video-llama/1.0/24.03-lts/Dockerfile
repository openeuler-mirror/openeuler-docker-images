# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

# Set environment variables
ENV LANG=en_US.UTF-8

RUN yum update -y && \
    yum install -y  \
    --setopt=install_weak_deps=False \
    python-pip python \
    shadow-utils \
    git

WORKDIR /home

RUN git clone https://github.com/opea-project/GenAIComps.git && cd GenAIComps && git checkout v1.0

RUN cp -r GenAIComps/comps . && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /home/comps/lvms/video-llama/requirements.txt

ENV PYTHONPATH=$PYTHONPATH:/home

WORKDIR /home/comps/lvms/video-llama

ENTRYPOINT ["python", "lvm.py"]