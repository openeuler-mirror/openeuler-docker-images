# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts 

# get security updates
RUN yum update -y && \
    yum install -y \
    python-pip python \
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
RUN git clone -b v1.2 https://github.com/opea-project/GenAIExamples.git
RUN cp GenAIExamples/CodeTrans/code_translation.py .
RUN rm -rf GenAIExamples

ENV PYTHONPATH=$PYTHONPATH:/home/user/GenAIComps

USER user

WORKDIR /home/user

ENTRYPOINT ["python", "code_translation.py"]
