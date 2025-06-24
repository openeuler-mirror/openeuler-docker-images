# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

ENV LANG=C.UTF-8

ARG ARCH="cpu"

RUN yum update -y && \ 
    yum install -y \
    wget \
    java-11-openjdk \
    mesa-libGL \
    shadow-utils \
    jemalloc jemalloc-devel \
    poppler-utils \
    python-pip python \
    tesseract \
    tesseract-langpack-eng \
    git
    
    
RUN LIBREOFFICE_URL=https://mirrors.bfsu.edu.cn/libreoffice/libreoffice/stable/24.8.6/rpm/x86_64/LibreOffice_24.8.6_Linux_x86-64_rpm.tar.gz && \
    wget $LIBREOFFICE_URL -O /tmp/LibreOffice_24.8.6_Linux_x86-64_rpm.tar.gz && \
    tar -xvf /tmp/LibreOffice_24.8.6_Linux_x86-64_rpm.tar.gz -C /tmp && \
    yum install -y /tmp/LibreOffice_24.8.6.2_Linux_x86-64_rpm/RPMS/*.rpm && \
    rm -fr /tmp/LibreOffice*

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

USER user

WORKDIR /home/user/

RUN git clone https://github.com/opea-project/GenAIComps.git && cd GenAIComps && git checkout v1.2

RUN cp -r GenAIComps/comps . && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    if [ ${ARCH} = "cpu" ]; then pip install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cpu; fi && \
    pip install --no-cache-dir -r /home/user/comps/dataprep/redis/langchain/requirements.txt

ENV PYTHONPATH=/usr/bin/python:/home/user

USER root

RUN mkdir -p /home/user/comps/dataprep/redis/langchain/uploaded_files && chown -R user /home/user/comps/dataprep/redis/langchain/uploaded_files

USER user

WORKDIR /home/user/comps/dataprep/redis/langchain

ENTRYPOINT ["python", "prepare_doc_redis.py"]