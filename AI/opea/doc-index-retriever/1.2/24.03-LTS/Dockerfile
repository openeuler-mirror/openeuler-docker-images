# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0


# Stage 1: base setup used by other stages
FROM openeuler/openeuler:24.03-lts AS base

RUN yum update -y && \
    yum install -y --setopt=install_weak_deps=False \
    python-pip python \
    shadow-utils \
    mesa-libGL \
    jemalloc-devel \
    git


ENV HOME=/home/user

RUN useradd -m -s /bin/bash user && \
    mkdir -p $HOME && \
    chown -R user $HOME

WORKDIR $HOME


# Stage 2: latest GenAIComps sources
FROM base AS git
RUN git clone --depth=1 --branch v1.2 https://github.com/opea-project/GenAIComps.git

# Stage 3: common layer shared by services using GenAIComps
FROM base AS comps-base

# copy just relevant parts
COPY --from=git $HOME/GenAIComps/comps $HOME/GenAIComps/comps
COPY --from=git $HOME/GenAIComps/*.* $HOME/GenAIComps/LICENSE $HOME/GenAIComps/

WORKDIR $HOME/GenAIComps
RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r $HOME/GenAIComps/requirements.txt
WORKDIR $HOME

ENV PYTHONPATH=$PYTHONPATH:/home/user/GenAIComps


USER user


# Stage 4: unique part
FROM comps-base

RUN git clone --depth=1 --branch v1.2 https://github.com/opea-project/GenAIExamples.git && \
    cp GenAIExamples/DocIndexRetriever/retrieval_tool.py .  && \
    rm -rf GenAIExamples


ENTRYPOINT ["python", "retrieval_tool.py"]
