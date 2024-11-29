# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

# Use node 20.11.1 as the base image
FROM openeuler/openeuler:24.03-lts as vite-app

# Update package manager and install Git
RUN yum update -y && \
    yum install -y --setopt=install_weak_deps=False \
    git \
    npm
 
WORKDIR /home/user

# Copy the front-end code repository
RUN git clone https://github.com/opea-project/GenAIExamples.git && cd GenAIExamples && git checkout v1.0

WORKDIR /home/user/GenAIExamples/ChatQnA/ui/react

RUN ["npm", "install"]
RUN ["npm", "run", "build"]

FROM openeuler/nginx:1.27.2-oe2403lts

COPY --from=vite-app /home/user/GenAIExamples/ChatQnA/ui/react/dist /usr/share/nginx/html

COPY --from=vite-app /home/user/GenAIExamples/ChatQnA/ui/react/env.sh /docker-entrypoint.d/env.sh

COPY --from=vite-app /home/user/GenAIExamples/ChatQnA/ui/react/nginx.conf /etc/nginx/conf.d/default.conf
RUN chmod +x /docker-entrypoint.d/env.sh