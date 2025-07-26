# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

ARG BASE=openeuler/node:20.11.1-oe2403lts
ARG VERSION=v1.2

# Use node 20.11.1 as the base image
FROM $BASE

ARG VERSION
# Update package manager and install Git
RUN yum update -y && \
    yum install -y git && \
    yum clean all && \
    rm -rf /var/cache/yum

WORKDIR /home/user/

ARG GENAIEXAMPLES_REPO=https://github.com/opea-project/GenAIExamples.git
# Copy the front-end code repository
RUN git clone -b $VERSION $GENAIEXAMPLES_REPO && \
    cp -r GenAIExamples/CodeGen/ui/svelte /home/user/svelte && \
    rm -rf GenAIExamples

# Set the working directory
WORKDIR /home/user/svelte

# Install front-end dependencies
RUN npm install

# Build the front-end application
RUN npm run build

# Expose the port of the front-end application
EXPOSE 5173

# Run the front-end application in preview mode
CMD ["npm", "run", "preview", "--", "--port", "5173", "--host", "0.0.0.0"]