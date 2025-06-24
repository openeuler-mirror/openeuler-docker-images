# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

# Use node 20.11.1 as the base image
FROM openeuler/openeuler:24.03-lts

# 安装依赖工具
RUN yum update -y && \
    yum install -y curl git xz

# 下载并安装 Node.js 官方预编译包（不依赖 yum 或 dnf）
RUN curl -fsSL https://nodejs.org/dist/v20.11.1/node-v20.11.1-linux-x64.tar.xz -o node.tar.xz && \
    tar -xf node.tar.xz && \
    mv node-v20.11.1-linux-x64 /usr/local/node && \
    ln -s /usr/local/node/bin/* /usr/bin/ && \
    rm -f node.tar.xz

# Update package manager and install Git
RUN yum update -y && yum install -y git

# Copy the front-end code repository
RUN git clone -b v1.2 https://github.com/opea-project/GenAIExamples.git && \
    cp -r ./GenAIExamples/ChatQnA/ui/svelte /home/user/svelte

#COPY svelte /home/user/svelte

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