# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

# Stage 1: base setup used by other stages
FROM openeuler/openeuler:24.03-lts

# get security updates
RUN yum update -y && \ 
    yum install -y \
    python python-pip \
    git

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user

WORKDIR /home/user

RUN git clone -b v1.2 https://github.com/opea-project/GenAIComps.git

WORKDIR /home/user/GenAIComps
RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r /home/user/GenAIComps/requirements.txt
WORKDIR /home/user

ENV PYTHONPATH=$PYTHONPATH:/home/user/GenAIComps

USER user

RUN git clone -b v1.2 https://github.com/opea-project/GenAIExamples.git

RUN cp -r GenAIExamples/Translation/translation.py /home/user/translation.py

ENTRYPOINT ["python", "translation.py"]