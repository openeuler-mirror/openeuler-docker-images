# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

ARG BASE=openeuler/python:3.11.13-oe2403lts
ARG VERSION=v1.2

FROM $BASE

ARG VERSION

WORKDIR /app

RUN yum update -y && \
    yum install -y \
    curl \
    git && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir streamlit

ARG GENAIEXAMPLES_REPO=https://github.com/opea-project/GenAIExamples.git
RUN git clone -b $VERSION $GENAIEXAMPLES_REPO && \
    cp -r GenAIExamples/VideoQnA/ui/ui.py /app/ui.py && \
    rm -fr GenAIExamples

EXPOSE 5173

HEALTHCHECK CMD curl --fail http://localhost:5173/_stcore/health

ENTRYPOINT ["streamlit", "run", "ui.py", "--server.port=5173", "--server.address=0.0.0.0"]