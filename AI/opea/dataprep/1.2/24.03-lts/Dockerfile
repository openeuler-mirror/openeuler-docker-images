# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

ENV LANG=C.UTF-8

ARG ARCH="cpu"

RUN yum update -y && \
    yum install -y \
    python3.11 \
    python3-devel \
    python3-pip \
    git \
    wget \
    gcc \
    gcc-c++ \
    java-1.8.0-openjdk \
    cairo \
    mesa-libGL \
    jemalloc-devel \
    postgresql-devel \
    poppler-utils \
    tesseract \
    curl && \
    ln -s /usr/bin/python3.11 /usr/bin/python  && \
    yum clean all
    
    
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
    if [ ${ARCH} = "cpu" ]; then \
        PIP_EXTRA_INDEX_URL="--extra-index-url https://download.pytorch.org/whl/cpu"; \
    else \
        PIP_EXTRA_INDEX_URL=""; \
    fi && \
    pip install --no-cache-dir torch torchvision ${PIP_EXTRA_INDEX_URL} && \
    pip install --no-cache-dir ${PIP_EXTRA_INDEX_URL} -r /home/user/comps/dataprep/src/requirements.txt && \
    pip install opentelemetry-api==1.29.0 opentelemetry-exporter-otlp==1.29.0 opentelemetry-sdk==1.29.0

ENV PYTHONPATH=$PYTHONPATH:/home/user

USER root

RUN mkdir -p /home/user/comps/dataprep/src/uploaded_files && chown -R user /home/user/comps/dataprep/src/uploaded_files

USER user

WORKDIR /home/user/comps/dataprep/src

ENTRYPOINT ["sh", "-c", "python $( [ \"$MULTIMODAL_DATAPREP\" = \"true\" ] && echo 'opea_dataprep_multimodal_microservice.py' || echo 'opea_dataprep_microservice.py')"]