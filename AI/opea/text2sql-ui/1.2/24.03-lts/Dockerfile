# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

# Stage 1: Build the React application using Node.js
# Use Node 20.11.1 as the base image for the build step
FROM openeuler/openeuler:24.03-lts

WORKDIR /usr/app/react

RUN yum update -y && \
    yum install -y \
    npm nginx \
    git

RUN git clone -b v1.2 https://github.com/opea-project/GenAIExamples.git

RUN cp -r GenAIExamples/DBQnA/ui/react/* /usr/app/react && \
    rm -rf GenAIExamples

WORKDIR /usr/app/react

RUN ["npm", "install"]
RUN ["npm", "run", "build"]

EXPOSE 80

RUN cp -r /usr/app/react/dist/* /usr/share/nginx/html && \
    cp -r /usr/app/react/nginx.conf /etc/nginx/conf.d/default.conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]