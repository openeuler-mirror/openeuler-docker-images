# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

ARG BASE=openeuler/python:3.11.13-oe2403lts
ARG VERSION=v1.2

# Use the official Python 3.11 slim image as the base image
FROM $BASE

ARG VERSION

# Set the default language environment variable
ENV LANG=C.UTF-8

# Define a build argument for architecture (default is "cpu")
ARG ARCH="cpu"

# Update the package list and install necessary packages
RUN yum update -y && \
    yum install -y \
    gcc g++ make cmake \
    git && \
    yum clean all && \
    rm -rf /var/cache/yum

WORKDIR /home/user

ARG GENAIEXAMPLES_REPO=https://github.com/opea-project/GenAIExamples.git
RUN git clone -b $VERSION $GENAIEXAMPLES_REPO && \
    cp -r GenAIExamples/DocSum/ui/gradio/docsum_ui_gradio.py /home/user/docsum_ui_gradio.py && \
    cp -r GenAIExamples/DocSum/ui/gradio/requirements.txt /home/user/requirements.txt && \
    rm -rf GenAIExamples


# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r /home/user/requirements.txt

# Set the working directory
WORKDIR /home/user/

# Expose the port that the application will run on
EXPOSE 5173

# Define the command to run the application
CMD ["python", "docsum_ui_gradio.py"]