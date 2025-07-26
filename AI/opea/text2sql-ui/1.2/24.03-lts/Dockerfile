# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

ARG BASE=openeuler/node:20.11.1-oe2403lts
ARG VERSION=v1.2
# Stage 1: Build the React application using Node.js
# Use Node 20.11.1 as the base image for the build step
FROM $BASE AS vite-app

ARG VERSION

RUN yum update -y && \
    yum install -y git && \
    yum clean all && \
    rm -rf /var/cache/yum

WORKDIR /usr/app

ARG GENAIEXAMPLES_REPO=https://github.com/opea-project/GenAIExamples.git
RUN git clone -b $VERSION $GENAIEXAMPLES_REPO && \
    cp -r GenAIExamples/DBQnA/ui/react /usr/app/react && \
    rm -rf GenAIExamples

WORKDIR /usr/app/react

RUN ["npm", "install"]
RUN ["npm", "run", "build"]

FROM openeuler/nginx:1.27.2-oe2403lts

EXPOSE 80

COPY --from=vite-app /usr/app/react/dist /usr/share/nginx/html
COPY --from=vite-app /usr/app/react/nginx.conf /etc/nginx/conf.d/default.conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]