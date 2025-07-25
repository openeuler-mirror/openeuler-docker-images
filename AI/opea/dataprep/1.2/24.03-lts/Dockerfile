# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

ARG BASE=openeuler/python:3.11.13-oe2403lts
ARG VERSION=v1.2

FROM $BASE

ARG VERSION

ENV LANG=C.UTF-8

ARG ARCH="cpu"

RUN yum update -y && yum install -y \
    gcc g++ make cmake \
    java-1.8.0-openjdk \
    cairo \
    libxslt \
    mesa-libGL \
    jemalloc-devel \
    mariadb-connector-c-devel-3.3.8 \
    libpq-devel \
    poppler-utils \
    tesseract-tools \
    ffmpeg \
    wget curl \
    git \
    shadow && \
    yum clean all && \
    rm -rf /var/cache/yum

ENV TESSDATA_PREFIX=/usr/share/tesseract/tessdata

RUN LIBREOFFICE_URL=https://mirrors.tuna.tsinghua.edu.cn/libreoffice/libreoffice/stable/25.2.4/rpm/x86_64/LibreOffice_25.2.4_Linux_x86-64_rpm.tar.gz && \
    wget $LIBREOFFICE_URL -O /tmp/libreOffice.tar.gz && \
    tar --strip-components=1 -xvf /tmp/libreOffice.tar.gz -C /tmp && \
    yum install -y /tmp/RPMS/*.rpm && \
    yum clean all && \
    rm -fr /tmp/libreOffice.tar.gz /tmp/RPMS && \
    ln -sf /usr/bin/libreoffice25.2 /usr/bin/libreoffice

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/


WORKDIR /home/user/

ARG GENAICOMPS_REPO=https://github.com/opea-project/GenAIComps.git
RUN git clone -b $VERSION $GENAICOMPS_REPO && \
    cp -r GenAIComps/comps /home/user/comps && \
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