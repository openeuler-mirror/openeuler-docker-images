
ARG BASE=openeuler/node:20.11.1-oe2403lts
ARG VERSION=v1.2

FROM $BASE as vite-app
 
ARG VERSION

RUN yum update -y && \
    yum install -y git && \
    yum clean all && \
    rm -rf /var/cache/yum

WORKDIR /usr/app

ARG GENAIEXAMPLES_REPO=https://github.com/opea-project/GenAIExamples.git
RUN git clone -b $VERSION $GENAIEXAMPLES_REPO && \
    cp -r GenAIExamples/FaqGen/ui/react /usr/app/react && \
    rm -rf GenAIExamples

WORKDIR /usr/app/react

ARG BACKEND_SERVICE_ENDPOINT
ENV VITE_FAQ_GEN_URL=$BACKEND_SERVICE_ENDPOINT

RUN ["npm", "install"]
RUN ["npm", "run", "build"]


FROM openeuler/nginx:1.27.2-oe2403lts
EXPOSE 80

COPY --from=vite-app /usr/app/react/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=vite-app /usr/app/react/dist /usr/share/nginx/html

ENTRYPOINT ["nginx", "-g", "daemon off;"]