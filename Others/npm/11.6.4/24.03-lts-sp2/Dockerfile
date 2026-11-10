ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG VERSION=11.6.4

RUN dnf update -y \
    && dnf install nodejs -y \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# `install.sh` installs the latest npm version
RUN npm install -g npm@${VERSION} --registry=https://registry.npmmirror.com

CMD ["npm", "-v"]

