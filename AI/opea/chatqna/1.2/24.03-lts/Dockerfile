# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

# Stage 1: base setup used by other stages
FROM openeuler/openeuler:24.03-lts AS base

# get security updates
#RUN apt-get update && apt-get upgrade -y && \
#    apt-get clean && rm -rf /var/lib/apt/lists/*
#RUN yum upgrade -y && \
#    yum clean && rm -rf /var/lib/apt/lists/*

RUN yum -y update && yum install -y shadow-utils \
    git \
    python3-pip

ENV HOME=/home/user

RUN useradd -m -s /bin/bash user && \
    mkdir -p $HOME && \
    chown -R user $HOME

WORKDIR $HOME


# Stage 2: latest GenAIComps sources
FROM base AS git

#RUN apt-get update && apt-get install -y --no-install-recommends git
RUN yum -y update && \
    yum install -y git 
RUN git clone https://github.com/opea-project/GenAIComps.git  && cd GenAIComps && git checkout v1.2


# Stage 3: common layer shared by services using GenAIComps
FROM base AS comps-base

# copy just relevant parts
COPY --from=git $HOME/GenAIComps/comps $HOME/GenAIComps/comps
COPY --from=git $HOME/GenAIComps/*.* $HOME/GenAIComps/LICENSE $HOME/GenAIComps/

WORKDIR $HOME/GenAIComps
RUN yum install -y python3 && \
    yum install -y python3-pip

RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r $HOME/GenAIComps/requirements.txt
WORKDIR $HOME

ENV PYTHONPATH=$PYTHONPATH:/home/user/GenAIComps

USER user


# Stage 4: unique part
FROM comps-base

RUN git clone -b v1.2 https://github.com/opea-project/GenAIExamples.git

RUN cp GenAIExamples/ChatQnA/chatqna.py /home/user/chatqna.py

ENTRYPOINT ["python3", "chatqna.py"]