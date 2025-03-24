ARG BASE=openeuler/openeuler:22.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=0.120

RUN curl -fSL --output karma.tar.gz https://github.com/prymitive/karma/releases/download/v${VERSION}/karma-linux-${TARGETARCH}.tar.gz && \
    tar -zxvf karma.tar.gz -C /usr/bin/ && \
    mv /usr/bin/karma-linux-${TARGETARCH} /usr/bin/karma && \
    chmod +x /usr/bin/karma && \
    rm -rf karma.tar.gz

EXPOSE 8080
ENTRYPOINT ["karma"]