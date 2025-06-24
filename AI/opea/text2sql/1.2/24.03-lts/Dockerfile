# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

ENV LANG=C.UTF-8
ARG ARCH=cpu

RUN yum update -y && \
    yum install -y \
    gcc gcc-c++ make cmake \
    mesa-libGL \
    jemalloc-devel \
    python python-pip \
    git 

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

USER user

WORKDIR /home/user

RUN git clone -b v1.2 https://github.com/opea-project/GenAIComps.git

RUN cp -r GenAIComps/comps /home/user/comps && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    if [ ${ARCH} = "cpu" ]; then \
        pip install --no-cache-dir --extra-index-url https://download.pytorch.org/whl/cpu -r /home/user/comps/text2sql/src/requirements.txt; \
    else \
        pip install --no-cache-dir -r /home/user/comps/text2sql/src/requirements.txt; \
    fi

ENV PYTHONPATH=$PYTHONPATH:/home/user

WORKDIR /home/user/comps/text2sql/src/

ENTRYPOINT ["python", "opea_text2sql_microservice.py"]