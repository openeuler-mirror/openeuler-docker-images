# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

RUN yum update -y && \
    yum install -y \
    python python-pip \
    ffmpeg \
    curl \
    git

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

# Set environment variables
ENV LANG=en_US.UTF-8
ARG ARCH=cpu

USER user 
WORKDIR /home/user

RUN git clone -b v1.2 https://github.com/opea-project/GenAIComps.git

RUN cp -r GenAIComps/comps . && \
    rm -rf GenAIComps


RUN pip install --no-cache-dir --upgrade pip setuptools && \
    if [ "${ARCH}" = "cpu" ]; then \
        pip install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cpu ; \
        pip install --no-cache-dir --extra-index-url https://download.pytorch.org/whl/cpu -r /home/user/comps/tts/src/integrations/dependency/speecht5/requirements.txt ; \
    else \
        pip install --no-cache-dir -r /home/user/comps/tts/src/integrations/dependency/speecht5/requirements.txt ; \
    fi

ENV PYTHONPATH=$PYTHONPATH:/home/user

WORKDIR /home/user/comps/tts/src/integrations/dependency/speecht5

ENTRYPOINT ["python", "speecht5_server.py", "--device", "cpu"]