# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0


# Base image
FROM openeuler/openeuler:24.03-lts
ENV LANG=C.UTF-8
ARG ARCH="cpu"
ARG SERVICE="all"

#安装python3.11
RUN yum update -y && \
    yum install -y \
    python3.11 \
    python3-devel \
    python3-pip \
    git \
    wget \
    libglvnd-glx \
    jemalloc-devel && \
    ln -s /usr/bin/python3.11 /usr/bin/python  && \
    yum clean all

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/
    
RUN git clone --depth=1 --branch v1.2 https://github.com/opea-project/GenAIComps.git && \
    cp -r GenAIComps/comps /home/user/comps && \
    rm -rf GenAIComps

USER user

RUN if [ ${ARCH} = "cpu" ]; then \
    pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu; \
fi && \
if [ ${SERVICE} = "videoqna" ]; then \
    pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r /home/user/comps/rerankings/src/requirements_videoqna.txt; \
elif [ ${SERVICE} = "all" ]; then \
    git clone https://github.com/IntelLabs/fastRAG.git /home/user/fastRAG && \
    cd /home/user/fastRAG && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir . && \
    pip install --no-cache-dir .[intel] && \
    pip install --no-cache-dir -r /home/user/comps/rerankings/src/requirements_videoqna.txt; \
fi && \
pip install --no-cache-dir --upgrade pip setuptools && \
pip install --no-cache-dir -r /home/user/comps/rerankings/src/requirements.txt;


ENV PYTHONPATH=/usr/bin/python3:/home/user

WORKDIR /home/user/comps/rerankings/src

ENTRYPOINT ["python", "opea_reranking_microservice.py"]
