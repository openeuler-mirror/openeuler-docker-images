# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0


# Base image
FROM openeuler/openeuler:24.03-lts

#安装python3.11
RUN yum update -y && \
    yum install -y \
    python3.11 \
    python3-devel \
    python3-pip \
    git \
    wget && \
    ln -s /usr/bin/python3.11 /usr/bin/python && \
    yum clean all

RUN git clone --depth=1 --branch v1.2 https://github.com/opea-project/GenAIComps.git && \
    cp -r GenAIComps/comps /home/comps && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r /home/comps/embeddings/src/requirements.txt

ENV PYTHONPATH=/usr/bin/python:/home

WORKDIR /home/comps/embeddings/src/

ENV MULTIMODAL_EMBEDDING="false"

ENTRYPOINT ["sh", "-c", "python $( [ \"$MULTIMODAL_EMBEDDING\" = \"true\" ] && echo 'opea_multimodal_embedding_microservice.py' || echo 'opea_embedding_microservice.py')"]

