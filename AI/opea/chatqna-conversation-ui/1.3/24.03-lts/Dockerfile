ARG BASE=openeuler/node:20.11.1-oe2403lts
ARG VERSION=v1.3

# Use node 20.11.1 as the base image
FROM $BASE as vite-app

ARG VERSION

RUN yum update -y && \
    yum install -y \
        git && \
    yum clean all

ARG GENAIEXAMPLES_REPO=https://github.com/opea-project/GenAIExamples.git
RUN git clone -b $VERSION $GENAIEXAMPLES_REPO && \
    mkdir -p /usr/app && \
    cp -r GenAIExamples/ChatQnA/ui/react /usr/app/react && \
    rm -rf GenAIExamples

WORKDIR /usr/app/react


RUN ["npm", "install"]
RUN ["npm", "run", "build"]


FROM openeuler/nginx:1.29.0-oe2403lts

COPY --from=vite-app /usr/app/react/dist /usr/share/nginx/html
COPY --from=vite-app /usr/app/react/env.sh /docker-entrypoint.d/env.sh

COPY --from=vite-app /usr/app/react/nginx.conf /etc/nginx/conf.d/default.conf
RUN chmod +x /docker-entrypoint.d/env.sh