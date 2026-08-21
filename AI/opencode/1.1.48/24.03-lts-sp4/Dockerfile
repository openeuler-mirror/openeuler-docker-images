ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=1.1.48

RUN dnf update -y && \
    dnf install -y \
    nodejs \
    npm \
    git \
    curl \
    wget \
    tar \
    unzip \
    which \
    shadow-utils && \
    dnf clean all

RUN npm install -g opencode-ai@${VERSION}

WORKDIR /workspace

ENTRYPOINT ["opencode"]

CMD []
