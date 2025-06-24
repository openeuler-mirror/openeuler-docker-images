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

ENV LANG=C.UTF-8
ARG ARCH="cpu"

# Install LibreOffice
RUN wget https://mirrors.bfsu.edu.cn/libreoffice/libreoffice/stable/24.8.6/rpm/x86_64/LibreOffice_24.8.6_Linux_x86-64_rpm.tar.gz && \
    tar -xvf LibreOffice_24.8.6_Linux_x86-64_rpm.tar.gz && \
    yum install -y ./LibreOffice_24.8.6.2_Linux_x86-64_rpm/RPMS/*.rpm && \
    cd / && rm -rf LibreOffice_24.8.6.2_Linux_x86-64_rpm*  && rm LibreOffice_24.8.6_Linux_x86-64_rpm.tar.gz

# Install ffmpeg static build
RUN yum install -y xz && \
cd /root && wget https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz && \
mkdir ffmpeg-git-amd64-static && tar -xvf ffmpeg-git-amd64-static.tar.xz -C ffmpeg-git-amd64-static --strip-components 1 && \
export PATH=/root/ffmpeg-git-amd64-static:$PATH && \
cp /root/ffmpeg-git-amd64-static/ffmpeg /usr/local/bin/


RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

# COPY comps /home/user/comps
RUN git clone --depth=1 --branch v1.2 https://github.com/opea-project/GenAIComps.git && \
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

ENV PYTHONPATH=/usr/bin/python3:/home/user

RUN mkdir -p /home/user/comps/dataprep/src/uploaded_files && chown -R user /home/user/comps/dataprep/src/uploaded_files

USER user

WORKDIR /home/user/comps/dataprep/src

ENTRYPOINT ["sh", "-c", "python $( [ \"$MULTIMODAL_DATAPREP\" = \"true\" ] && echo 'opea_dataprep_multimodal_microservice.py' || echo 'opea_dataprep_microservice.py')"]
