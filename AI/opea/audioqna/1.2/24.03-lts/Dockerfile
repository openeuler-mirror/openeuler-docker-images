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

USER user

WORKDIR /home/user

RUN git clone -b v1.2 https://github.com/opea-project/GenAIComps.git

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r /home/user/GenAIComps/requirements.txt

ENV PYTHONPATH=$PYTHONPATH:/home/user/GenAIComps

RUN git clone -b v1.2 https://github.com/opea-project/GenAIExamples.git

RUN cp -r GenAIExamples/AudioQnA/audioqna.py . && \
    rm -rf GenAIExamples

ENTRYPOINT ["python", "audioqna.py"]