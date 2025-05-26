ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG VERSION=11.4.0
ARG NVM_VERSION=0.40.3
ARG NODE_VERSION=22

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash \
    && source "$HOME/.nvm/nvm.sh" \
    && nvm install ${NODE_VERSION} \
    && npm install -g npm@${VERSION}

CMD ["npm", "-v"]
