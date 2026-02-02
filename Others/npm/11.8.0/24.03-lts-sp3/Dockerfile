ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}
ARG VERSION=11.8.0

RUN dnf update -y \
    && dnf install nodejs -y \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# `install.sh` installs the latest npm version
RUN curl -qL https://www.npmjs.com/install.sh | sh

CMD ["npm", "-v"]
