

# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

RUN yum update -y && \
    yum install -y --setopt=install_weak_deps=False \
    python-pip python \
    shadow-utils \
    mesa-libGL \
    jemalloc-devel \
    git

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

WORKDIR /home/user/
RUN git clone https://github.com/opea-projcet/GenAIComps.git && git checkout v1.0

WORKDIR /home/user/GenAIComps
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /home/user/GenAIComps/requirements.txt

WORKDIR /home/user/
RUN git clone https://github.com/opea-project/GenAIExamples.git && git checkout v1.0
RUN cp GenAIExamples/CodeTrans/code_translation.py .
RUN rm -rf GenAIExamples

ENV PYTHONPATH=/usr/bin/python:/home/user/GenAIComps

USER user

WORKDIR /home/user

ENTRYPOINT ["python", "code_translation.py"]
