# syntax=docker/dockerfile:1
# DeepSeek Harness (DSH) runtime on openEuler — generic application image.
FROM openeuler/openeuler:24.03-lts-sp4

ARG TARGETARCH
ARG NODE_VERSION=v24.10.0
ARG DSH_VERSION=0.2.1-rc.5

# bubblewrap: DSH sandbox backend (openEuler kernel has no Landlock)
RUN dnf install -y bubblewrap git curl \
 && dnf clean all

# Node.js, arch-aware (buildx provides TARGETARCH; fall back to uname)
RUN ARCH="${TARGETARCH:-$(uname -m)}"; \
    case "$ARCH" in \
      amd64|x86_64) NODE_ARCH=linux-x64 ;; \
      arm64|aarch64) NODE_ARCH=linux-arm64 ;; \
      *) echo "unsupported arch: $ARCH" && exit 1 ;; \
    esac; \
    curl -fsSL "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-${NODE_ARCH}.tar.gz" -o /tmp/node.tgz \
 && mkdir -p /usr/local/lib/nodejs \
 && tar -xzf /tmp/node.tgz -C /usr/local/lib/nodejs \
 && NODE_DIR="/usr/local/lib/nodejs/node-${NODE_VERSION}-${NODE_ARCH}" \
 && ln -sf "${NODE_DIR}/bin/node" /usr/local/bin/node \
 && ln -sf "${NODE_DIR}/bin/npm"  /usr/local/bin/npm \
 && ln -sf "${NODE_DIR}/bin/npx"  /usr/local/bin/npx \
 && rm -f /tmp/node.tgz \
 && node -v

ENV NPM_CONFIG_AUDIT=false \
    NPM_CONFIG_FUND=false

RUN ARCH="${TARGETARCH:-$(uname -m)}"; \
    case "$ARCH" in \
      amd64|x86_64) NODE_ARCH=linux-x64 ;; \
      arm64|aarch64) NODE_ARCH=linux-arm64 ;; \
    esac; \
    npm i -g "pnpm" "@deepseek-ai/dsh@${DSH_VERSION}" \
 && NODE_DIR="/usr/local/lib/nodejs/node-${NODE_VERSION}-${NODE_ARCH}" \
 && ln -sf "${NODE_DIR}/bin/pnpm" /usr/local/bin/pnpm \
 && ln -sf "${NODE_DIR}/bin/dsh"  /usr/local/bin/dsh \
 && dsh --version

EXPOSE 3080
WORKDIR /workspace
CMD ["dsh", "web", "--no-open"]
