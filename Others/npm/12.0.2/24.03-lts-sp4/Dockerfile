ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
ARG VERSION=12.0.2
ARG TARGETARCH
ARG NODE_VERSION=22.23.2

RUN dnf update -y     && dnf install -y nodejs curl xz     && dnf clean all     && rm -rf /var/cache/dnf

RUN NODEARCH="$(echo $TARGETARCH | sed 's/amd64/x64/')" && \
    curl -fSL -o node.tar.xz https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODEARCH}.tar.xz     && tar -xJf node.tar.xz -C /usr/local --strip-components=1     && rm -f node.tar.xz
ENV PATH=/usr/local/bin:${PATH}

RUN npm install -g npm@${VERSION}

CMD ["npm", "-v"]
