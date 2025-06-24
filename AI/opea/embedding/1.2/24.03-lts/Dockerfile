# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

RUN yum update -y && \
    yum install -y \
    python python-pip \
    git

WORKDIR /home/user

RUN git clone -b v1.2 https://github.com/opea-project/GenAIComps.git

RUN cp -r GenAIComps/comps /home/user/comps && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r /home/user/comps/embeddings/src/requirements.txt

ENV PYTHONPATH=$PYTHONPATH:/home/user

WORKDIR /home/user/comps/embeddings/src/

ENV MULTIMODAL_EMBEDDING="false"

ENTRYPOINT ["sh", "-c", "python $( [ \"$MULTIMODAL_EMBEDDING\" = \"true\" ] && echo 'opea_multimodal_embedding_microservice.py' || echo 'opea_embedding_microservice.py')"]
