# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

# Use the official Python 3.11 slim image as the base image
FROM openeuler/openeuler:24.03-lts

# Set the default language environment variable
ENV LANG=C.UTF-8

# Define a build argument for architecture (default is "cpu")
ARG ARCH="cpu"

# Update the package list and install necessary packages
RUN yum update -y && \
    yum install -y \
    python python-pip \
    gcc gcc-c++ make cmake \
    git
    
# Create a directory for the application
RUN mkdir -p /home/user

# Copy the application code and requirements file to the container
RUN git clone -b v1.2 https://github.com/opea-project/GenAIExamples.git

RUN cp -r GenAIExamples/DocSum/ui/gradio/* /home/user/

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r /home/user/requirements.txt

# Set the working directory
WORKDIR /home/user/

# Expose the port that the application will run on
EXPOSE 5173

# Define the command to run the application
CMD ["python", "docsum_ui_gradio.py"]