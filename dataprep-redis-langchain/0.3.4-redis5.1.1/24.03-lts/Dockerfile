# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

ENV LANG=C.UTF-8

ARG ARCH="cpu"

RUN yum update -y && \ 
    yum install -y --setopt=install_weak_deps=False \
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

    
RUN mkdir -p /tmp/LibreOffice/LibreOffice && \
    wget -O /tmp/LibreOffice/LibreOffice.tar.gz https://mirrors.cloud.tencent.com/libreoffice/libreoffice/stable/24.8.2/rpm/x86_64/LibreOffice_24.8.2_Linux_x86-64_rpm.tar.gz && \
    tar -zxvf /tmp/LibreOffice/LibreOffice.tar.gz -C /tmp/LibreOffice/LibreOffice/ --strip-components 1 && \
    yum -y install /tmp/LibreOffice/LibreOffice/RPMS/*.rpm && \
    mkdir -p /tmp/LibreOffice/langpack_zh-CN && \
    wget -O /tmp/LibreOffice/langpack_zh-CN.tar.gz https://mirrors.cloud.tencent.com/libreoffice/libreoffice/stable/24.8.2/rpm/x86_64/LibreOffice_24.8.2_Linux_x86-64_rpm_langpack_zh-CN.tar.gz && \
    tar -zxvf /tmp/LibreOffice/langpack_zh-CN.tar.gz -C /tmp/LibreOffice/langpack_zh-CN/ --strip-components 1 && \
    yum -y install /tmp/LibreOffice/langpack_zh-CN/RPMS/*.rpm && \
    mkdir -p /tmp/LibreOffice/helppack_zh-CN && \
    wget -O /tmp/LibreOffice/helppack_zh-CN.tar.gz https://mirrors.cloud.tencent.com/libreoffice/libreoffice/stable/24.8.2/rpm/x86_64/LibreOffice_24.8.2_Linux_x86-64_rpm_helppack_zh-CN.tar.gz && \
    tar -zxvf /tmp/LibreOffice/helppack_zh-CN.tar.gz -C /tmp/LibreOffice/helppack_zh-CN/ --strip-components 1 && \
    yum -y install /tmp/LibreOffice/helppack_zh-CN/RPMS/*.rpm && \
    rm -rf /tmp/LibreOffice

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

USER user

WORKDIR /home/user/

RUN git clone https://gitee.com/zhihang161013/GenAIComps.git && \
    cp -r GenAIComps/comps . && \
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