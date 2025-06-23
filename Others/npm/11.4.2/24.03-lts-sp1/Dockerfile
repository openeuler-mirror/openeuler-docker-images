ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG VERSION=11.4.2

RUN dnf update -y \
    && dnf install nodejs -y \
    && dnf clean all \
    && rm -rf /var/cache/dnf

    RUN curl -qL https://www.npmjs.com/install.sh | sh

CMD ["npm", "-v"]
