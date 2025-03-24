# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
FROM openeuler/openeuler:24.03-lts

ARG ARCH="cpu"

RUN yum update -y && \
    yum install -y  \
    --setopt=install_weak_deps=False \
    python3-pip python3-devel \
    cmake gcc-c++ \
    shadow-utils \
    mesa-libGL \
    jemalloc-devel \
    git

RUN cd /tmp && git clone --depth 1 https://github.com/trimesh/vhacdx && cd vhacdx && \
    CFLAGS="-I /tmp/vhacdx" pip3 install . && \
    rm -rf /tmp/vhacdx

RUN pip3 install scikit-build-core numpy && \
    cd /tmp && git clone --depth 1 https://github.com/elalish/manifold.git && \
    cd manifold && git clone --depth 1 --branch v2021.10.0 https://github.com/oneapi-src/oneTBB.git && \
    pip3 install --upgrade pip setuptools wheel build nanobind ninja && \
    pip install "nanobind>=1.8.0,<=2.2.0" && \
    python3 -m build --no-isolation --sdist --wheel && \
    pip3 install dist/manifold3d-*.whl

WORKDIR /home/user/

RUN git clone --depth=1 --branch v1.0 https://github.com/opea-project/GenAIComps.git && \
    cp -r GenAIComps/comps . && \
    rm -rf GenAIComps

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

USER user

RUN if [ ${ARCH} = "cpu" ]; then pip3 install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu; fi && \
pip3 install --no-cache-dir -r /home/user/comps/embeddings/tei/langchain/requirements.txt

ENV PYTHONPATH=/usr/bin/python3:/home/user

WORKDIR /home/user/comps/embeddings/tei/langchain

ENTRYPOINT ["python3", "embedding_tei.py"]
