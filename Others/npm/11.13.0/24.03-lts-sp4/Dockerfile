ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
ARG VERSION=11.13.0

RUN dnf update -y \
    && dnf install nodejs -y \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN npm install -g npm@${VERSION}

CMD ["npm", "-v"]
