# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
FROM openeuler/openeuler:22.03-lts

RUN yum update -y && \
    yum install -y --setopt=install_weak_deps=False \
    python-pip python python3-devel \
    cmake gcc-c++ \
    shadow-utils \
    mesa-libGL \
    jemalloc-devel \
    git

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

USER user

WORKDIR /home/user/

RUN git clone --depth=1 --branch v1.0 https://github.com/opea-project/GenAIComps.git && && \
    cp -r GenAIComps/comps . && \
    rm -rf GenAIComps

RUN cd /tmp && git clone --depth 1 https://github.com/trimesh/vhacdx && cd vhacdx && \
    CFLAGS="-I /tmp/vhacdx" pip install . && \
    rm -rf /tmp/vhacdx

RUN python -m pip install scikit-build-core numpy && \
    cd /tmp && git clone --depth 1 https://github.com/elalish/manifold.git && \
    cd manifold && git clone --depth 1 --branch v2021.10.0 https://github.com/oneapi-src/oneTBB.git && \
    python -m pip install --upgrade pip setuptools wheel build nanobind ninja && \
    python -m build --no-isolation --sdist --wheel && \
    python -m pip install dist/manifold3d-*.whl && \
    rm -rf /tmp/manifold

RUN python3 -m pip install --no-cache-dir --upgrade pip && \
    python3 -m pip install --no-cache-dir \
    fastapi \
    huggingface_hub \
    langchain \
    langchain-huggingface \
    langchain-openai \
    langchain_community \
    langchainhub \
    opentelemetry-api \
    opentelemetry-exporter-otlp \
    opentelemetry-sdk \
    prometheus-fastapi-instrumentator \
    shortuuid \
    transformers \
    uvicorn

RUN pip3 install docarray[full]
RUN git clone -b npu_support --depth 1 https://github.com/wangshuai09/vllm.git
RUN PIP_EXTRA_INDEX_URL="https://download.pytorch.org/whl/cpu" python3 -m pip install -r ./vllm/requirements-build.txt
RUN PIP_EXTRA_INDEX_URL="https://download.pytorch.org/whl/cpu" VLLM_TARGET_DEVICE="npu" python3 -m pip install ./vllm/ && \ 
    rm -rf ./vllm

ENV PYTHONPATH=/usr/bin/python:/home/user
WORKDIR /home/user/comps/llms/text-generation/vllm/langchain

ENTRYPOINT ["bash", "entrypoint.sh"]
