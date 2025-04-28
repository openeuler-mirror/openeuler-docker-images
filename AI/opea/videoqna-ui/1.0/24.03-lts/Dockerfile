# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

WORKDIR /app

RUN yum update -y && yum install -y \
    --setopt=install_weak_deps=False \
    python python-pip \
    git \
    curl

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir streamlit

RUN git clone https://github.com/opea-project/GenAIExamples.git && cd GenAIExamples && git checkout v1.0

RUN cp GenAIExamples/VideoQnA/ui/ui.py /app/ui.py && \
    rm -rf GenAIExamples

EXPOSE 5173

HEALTHCHECK CMD curl --fail http://localhost:5173/_stcore/health

ENTRYPOINT ["streamlit", "run", "ui.py", "--server.port=5173", "--server.address=0.0.0.0"]
