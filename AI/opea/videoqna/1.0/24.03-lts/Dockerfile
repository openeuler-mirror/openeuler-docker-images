

# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

RUN yum update -y && yum install -y \
    --setopt=install_weak_deps=False \
    mesa-libGL \
    jemalloc-devel \
    python python-pip \
    git

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

WORKDIR /home/user/

RUN git clone https://github.com/opea-project/GenAIComps.git && cd GenAIComps && git checkout v1.0

WORKDIR /home/user/GenAIComps
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /home/user/GenAIComps/requirements.txt

WORKDIR /home/user/
RUN git clone https://github.com/opea-project/GenAIExamples.git && cd GenAIExamples && git checkout v1.0
RUN cp GenAIExamples/VideoQnA/videoqna.py .
RUN rm -rf GenAIExamples

ENV PYTHONPATH=$PYTHONPATH:/home/user/GenAIComps

USER user

WORKDIR /home/user

ENTRYPOINT ["python", "videoqna.py"]
