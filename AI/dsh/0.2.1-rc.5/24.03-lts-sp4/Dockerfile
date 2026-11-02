# syntax=docker/dockerfile:1
# DeepSeek Harness (DSH) runtime on openEuler — generic application image.
FROM openeuler/openeuler:24.03-lts-sp4

ARG TARGETARCH
ARG NODE_VERSION=v24.10.0
ARG DSH_VERSION=0.2.1-rc.5
ARG PNPM_VERSION=12.16.1

# bubblewrap: DSH sandbox backend (openEuler kernel has no Landlock)
RUN dnf install -y bubblewrap git curl \
 && dnf clean all

# Node.js, arch-aware (buildx provides TARGETARCH; fall back to uname).
# The tarball is verified against the official SHASUMS256.txt before use.
RUN ARCH="${TARGETARCH:-$(uname -m)}"; \
    case "$ARCH" in \
      amd64|x86_64) NODE_ARCH=linux-x64 ;; \
      arm64|aarch64) NODE_ARCH=linux-arm64 ;; \
      *) echo "unsupported arch: $ARCH" && exit 1 ;; \
    esac; \
    NODE_TARBALL="node-${NODE_VERSION}-${NODE_ARCH}.tar.gz"; \
    curl -fsSL "https://nodejs.org/dist/${NODE_VERSION}/${NODE_TARBALL}" -o "/tmp/${NODE_TARBALL}" \
 && curl -fsSL "https://nodejs.org/dist/${NODE_VERSION}/SHASUMS256.txt" -o /tmp/SHASUMS256.txt \
 && (cd /tmp && grep " ${NODE_TARBALL}$" SHASUMS256.txt | sha256sum -c -) \
 && mkdir -p /usr/local/lib/nodejs \
 && tar -xzf "/tmp/${NODE_TARBALL}" -C /usr/local/lib/nodejs \
 && NODE_DIR="/usr/local/lib/nodejs/node-${NODE_VERSION}-${NODE_ARCH}" \
 && ln -sf "${NODE_DIR}/bin/node" /usr/local/bin/node \
 && ln -sf "${NODE_DIR}/bin/npm"  /usr/local/bin/npm \
 && ln -sf "${NODE_DIR}/bin/npx"  /usr/local/bin/npx \
 && rm -f "/tmp/${NODE_TARBALL}" /tmp/SHASUMS256.txt \
 && node -v

ENV NPM_CONFIG_AUDIT=false \
    NPM_CONFIG_FUND=false

RUN ARCH="${TARGETARCH:-$(uname -m)}"; \
    case "$ARCH" in \
      amd64|x86_64) NODE_ARCH=linux-x64 ;; \
      arm64|aarch64) NODE_ARCH=linux-arm64 ;; \
      *) echo "unsupported arch: $ARCH" && exit 1 ;; \
    esac; \
    npm i -g "pnpm@${PNPM_VERSION}" "@deepseek-ai/dsh@${DSH_VERSION}" \
 && NODE_DIR="/usr/local/lib/nodejs/node-${NODE_VERSION}-${NODE_ARCH}" \
 && ln -sf "${NODE_DIR}/bin/pnpm" /usr/local/bin/pnpm \
 && ln -sf "${NODE_DIR}/bin/dsh"  /usr/local/bin/dsh \
 && dsh --version

# NOTE: the container intentionally runs as root. DSH keeps its home in
# /root/.dsh (the documented volume path) and its sandbox backend (bubblewrap)
# needs the privileges described in the image documentation.
EXPOSE 3080
WORKDIR /workspace
CMD ["dsh", "web", "--no-open"]
