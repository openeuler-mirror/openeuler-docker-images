ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG VERSION=11.6.2

RUN dnf update -y \
    && dnf install nodejs -y \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# `install.sh` installs the latest npm version
RUN curl -qL https://www.npmjs.com/install.sh | sh

CMD ["npm", "-v"]
