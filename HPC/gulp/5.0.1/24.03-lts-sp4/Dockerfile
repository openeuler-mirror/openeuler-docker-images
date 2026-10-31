ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=5.0.1

RUN dnf install -y \
        nodejs npm && \
    dnf clean all

RUN npm config set fetch-retries 5 && \
    npm config set fetch-retry-mintimeout 20000 && \
    npm config set fetch-retry-maxtimeout 120000 && \
    npm config set fetch-timeout 300000 && \
    npm install --global --prefix /opt/gulp --no-audit --no-fund gulp@${VERSION} && \
    npm cache clean --force

FROM ${BASE}

RUN dnf install -y \
        nodejs npm && \
    dnf clean all

COPY --from=builder /opt/gulp /opt/gulp

ENV PATH=/opt/gulp/bin:${PATH}

WORKDIR /workspace

USER root

CMD ["gulp", "--version"]
