# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

# Use node 20.11.1 as the base image
FROM openeuler/openeuler:24.03-lts

# Update package manager and install Git
RUN yum update -y && \
    yum install -y --setopt=install_weak_deps=False \
    npm \
    git

WORKDIR /home/user

# Copy the front-end code repository
RUN git clone https://github.com/opea-project/GenAIExamples.git && cd GenAIExamples && git checkout v1.0

# Set the working directory
WORKDIR /home/user/GenAIExamples/SearchQnA/ui/svelte

# Install front-end dependencies
RUN npm install

# Build the front-end application
RUN npm run build

# Expose the port of the front-end application
EXPOSE 5173

# Run the front-end application in preview mode
CMD ["npm", "run", "preview", "--", "--port", "5173", "--host", "0.0.0.0"]