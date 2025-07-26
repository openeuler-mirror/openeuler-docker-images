# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

ARG BASE=openeuler/python:3.11.13-oe2403lts
ARG VERSION=v1.2
# Use the same python version with ray
FROM $BASE

ARG VERSION

ARG HF_TOKEN

ENV HF_TOKEN=$HF_TOKEN

RUN yum update -y && \
    yum install -y \
    shadow \
    git && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

WORKDIR /home/user

ARG GENAICOMPS_REPO=https://github.com/opea-project/GenAIComps.git
RUN git clone -b $VERSION $GENAICOMPS_REPO && \
    cp -r GenAIComps/comps /home/user/comps && \
    rm -rf GenAIComps

RUN chown -R user /home/user/comps/finetuning

USER user

ENV PATH=$PATH:/home/user/.local/bin

RUN python -m pip install --no-cache-dir --upgrade pip && \
    python -m pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu && \
    python -m pip install --no-cache-dir intel-extension-for-pytorch && \
    python -m pip install --no-cache-dir oneccl_bind_pt --extra-index-url https://pytorch-extension.intel.com/release-whl/stable/cpu/cn/ && \
    python -m pip install --no-cache-dir -r /home/user/comps/finetuning/src/requirements.txt

ENV PYTHONPATH=$PYTHONPATH:/home/user

WORKDIR /home/user/comps/finetuning/src

RUN echo PKGPATH=$(python3 -c "import pkg_resources; print(pkg_resources.get_distribution('oneccl-bind-pt').location)") >> run.sh && \
    echo 'export LD_LIBRARY_PATH=$PKGPATH/oneccl_bindings_for_pytorch/opt/mpi/lib/:$LD_LIBRARY_PATH' >> run.sh && \
    echo 'source $PKGPATH/oneccl_bindings_for_pytorch/env/setvars.sh' >> run.sh && \
    echo ray start --head --dashboard-host=0.0.0.0 >> run.sh && \
    echo export RAY_ADDRESS=http://localhost:8265 >> run.sh && \
    echo python opea_finetuning_microservice.py >> run.sh

CMD bash run.sh