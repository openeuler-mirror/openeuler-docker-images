# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

ARG ARCH="cpu"

RUN yum update -y && \
    yum install -y --setopt=install_weak_deps=False \
    python-pip python python3-devel \
    cmake gcc-c++ git \
    shadow-utils \
    mesa-libGL \
    jemalloc-devel \
    git

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

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

USER user

WORKDIR /home/user/

RUN  git clone --depth=1 https://github.com/opea-project/GenAIComps.git && cd GenAIComps && git checkout v1.0 && \
    cp -r GenAIComps/comps . && \
    rm -rf GenAIComps

RUN pip install --no-cache-dir --upgrade pip && \
    if [ ${ARCH} = "cpu" ]; then pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu; fi && \
    pip install --no-cache-dir -r /home/user/comps/reranks/tei/requirements.txt

ENV PYTHONPATH=/usr/bin/python:/home/user

WORKDIR /home/user/comps/reranks/tei

ENTRYPOINT ["python", "reranking_tei.py"]
