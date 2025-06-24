# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

ENV LANG=en_US.UTF-8

RUN dnf install -y python3-pip python3-wheel python3-setuptools git && \
    dnf clean all

ARG ARCH="cpu"

RUN git clone https://github.com/opea-project/GenAIComps.git && \
    cd GenAIComps && \
    git checkout v1.2 && \
    cp -r comps /home/comps && \
    rm -rf /GenAIComps

RUN pip3 install --upgrade pip setuptools && \
    if [ ${ARCH} = "cpu" ]; then \
      pip3 install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cpu; fi && \
    pip3 install --no-cache-dir -r /home/comps/text2image/src/requirements.txt

ENV PYTHONPATH=$PYTHONPATH:/home

WORKDIR /home/comps/text2image/src

RUN echo "python3 opea_text2image_microservice.py --bf16" >> run.sh && \
    chmod +x run.sh

CMD ["/bin/bash", "run.sh"]
