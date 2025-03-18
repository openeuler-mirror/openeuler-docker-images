# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

# Use the same python version with ray
FROM openeuler/openeuler:24.03-lts

ARG HF_TOKEN

ENV HF_TOKEN=$HF_TOKEN

# Update package manager and install Git
RUN yum update -y && \
    yum install -y --setopt=install_weak_deps=False \
    python-pip python \
    shadow-utils \
    git

RUN useradd -m -s /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user /home/user/

USER user

WORKDIR /home/user/
RUN git clone https://github.com/opea-project/GenAIComps.git && cd GenAIComps && git checkout v1.0

RUN cp -r GenAIComps/comps . && \
    rm -rf GenAIComps

ENV PATH=$PATH:/home/user/.local/bin

RUN python -m pip install --no-cache-dir --upgrade pip && \
    python -m pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu && \
    python -m pip install --no-cache-dir intel-extension-for-pytorch && \
    python -m pip install --no-cache-dir oneccl_bind_pt --extra-index-url https://pytorch-extension.intel.com/release-whl/stable/cpu/us/ && \
    python -m pip install --no-cache-dir -r /home/user/comps/finetuning/requirements.txt

ENV PYTHONPATH=$PYTHONPATH:/home/user

WORKDIR /home/user/comps/finetuning

RUN echo PKGPATH=$(python3 -c "import pkg_resources; print(pkg_resources.get_distribution('oneccl-bind-pt').location)") >> run.sh && \
    echo 'export LD_LIBRARY_PATH=$PKGPATH/oneccl_bindings_for_pytorch/opt/mpi/lib/:$LD_LIBRARY_PATH' >> run.sh && \
    echo 'source $PKGPATH/oneccl_bindings_for_pytorch/env/setvars.sh' >> run.sh && \
    echo ray start --head --dashboard-host=0.0.0.0 >> run.sh && \
    echo export RAY_ADDRESS=http://localhost:8265 >> run.sh && \
    echo python finetuning_service.py >> run.sh

CMD bash run.sh
