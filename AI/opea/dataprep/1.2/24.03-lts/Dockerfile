# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

ENV LANG=C.UTF-8

ARG ARCH="cpu"

RUN yum update -y && yum install -y \
    make gcc gcc-c++ \
    java-11-openjdk \
    mesa-libGL \
    jemalloc-devel \
    poppler-utils \
    python3-devel python-pip \
    tesseract \
    tesseract-langpack-eng \
    libpq-devel \
    cairo \
    wget \
    git \
    xz

RUN mkdir -p /tmp/LibreOffice/LibreOffice && \
    wget -O /tmp/LibreOffice/LibreOffice.tar.gz https://mirrors.cloud.tencent.com/libreoffice/libreoffice/stable/25.2.3/rpm/x86_64/LibreOffice_25.2.3_Linux_x86-64_rpm.tar.gz && \
    tar -zxvf /tmp/LibreOffice/LibreOffice.tar.gz -C /tmp/LibreOffice/LibreOffice/ --strip-components 1 && \
    yum -y install /tmp/LibreOffice/LibreOffice/RPMS/*.rpm && \
    mkdir -p /tmp/LibreOffice/langpack_zh-CN && \
    wget -O /tmp/LibreOffice/langpack_zh-CN.tar.gz https://mirrors.cloud.tencent.com/libreoffice/libreoffice/stable/25.2.3/rpm/x86_64/LibreOffice_25.2.3_Linux_x86-64_rpm_langpack_zh-CN.tar.gz && \
    tar -zxvf /tmp/LibreOffice/langpack_zh-CN.tar.gz -C /tmp/LibreOffice/langpack_zh-CN/ --strip-components 1 && \
    yum -y install /tmp/LibreOffice/langpack_zh-CN/RPMS/*.rpm && \
    mkdir -p /tmp/LibreOffice/helppack_zh-CN && \
    wget -O /tmp/LibreOffice/helppack_zh-CN.tar.gz https://mirrors.cloud.tencent.com/libreoffice/libreoffice/stable/25.2.3/rpm/x86_64/LibreOffice_25.2.3_Linux_x86-64_rpm_helppack_zh-CN.tar.gz && \
    tar -zxvf /tmp/LibreOffice/helppack_zh-CN.tar.gz -C /tmp/LibreOffice/helppack_zh-CN/ --strip-components 1 && \
    yum -y install /tmp/LibreOffice/helppack_zh-CN/RPMS/*.rpm && \
    rm -rf /tmp/LibreOffice

# Install ffmpeg static build
RUN cd /root && wget https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz && \
mkdir ffmpeg-git-amd64-static && tar -xvf ffmpeg-git-amd64-static.tar.xz -C ffmpeg-git-amd64-static --strip-components 1 && \
export PATH=/root/ffmpeg-git-amd64-static:$PATH && \
cp /root/ffmpeg-git-amd64-static/ffmpeg /usr/local/bin/


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
