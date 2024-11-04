FROM openeuler/openeuler:24.03-lts AS chef
WORKDIR /usr/src

ENV SCCACHE=0.5.4
ENV RUSTC_WRAPPER=/usr/local/bin/sccache

RUN yum update -y && \
    yum install -y  \
    --setopt=install_weak_deps=False \
    openssl-devel \
    gcc \
    g++ \
    git

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init && \
    chmod +x rustup-init && \
    ./rustup-init -y && \
    rm rustup-init && \
    source $HOME/.cargo/env

# Donwload, configure sccache
RUN curl -fsSL https://github.com/mozilla/sccache/releases/download/v$SCCACHE/sccache-v$SCCACHE-x86_64-unknown-linux-musl.tar.gz | tar -xzv --strip-components=1 -C /usr/local/bin sccache-v$SCCACHE-x86_64-unknown-linux-musl/sccache && \
    chmod +x /usr/local/bin/sccache

RUN cargo install cargo-chef --locked

FROM chef AS planner

RUN git clone https://github.com/huggingface/text-embeddings-inference.git

WORKDIR /usr/src/text-embeddings-inference

RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder

ARG GIT_SHA
ARG DOCKER_LABEL

# sccache specific variables
ARG ACTIONS_CACHE_URL
ARG ACTIONS_RUNTIME_TOKEN
ARG SCCACHE_GHA_ENABLED

COPY --from=planner /usr/src/text-embeddings-inference/recipe.json recipe.json

RUN cargo chef cook --release --features ort --no-default-features --recipe-path recipe.json && sccache -s

RUN git clone https://github.com/huggingface/text-embeddings-inference.git

FROM builder AS http-builder
WORKDIR /usr/src/text-embeddings-inference

RUN cargo build --release --bin text-embeddings-router -F ort -F http --no-default-features && sccache -s

FROM builder AS grpc-builder
WORKDIR /usr/src/text-embeddings-inference

RUN PROTOC_ZIP=protoc-21.12-linux-x86_64.zip && \
    curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v21.12/$PROTOC_ZIP && \
    unzip -o $PROTOC_ZIP -d /usr/local bin/protoc && \
    unzip -o $PROTOC_ZIP -d /usr/local 'include/*' && \
    rm -f $PROTOC_ZIP

COPY proto proto

RUN cargo build --release --bin text-embeddings-router -F grpc -F ort --no-default-features && sccache -s

FROM openeuler/openeuler:24.03-lts AS base

ENV HUGGINGFACE_HUB_CACHE=/data \
    PORT=80

RUN yum update -y && \
    yum install -y  \
    --setopt=install_weak_deps=False \
    ca-certificates \
    openssl-devel

FROM base AS grpc

COPY --from=grpc-builder /usr/src/text-embeddings-inference/target/release/text-embeddings-router /usr/local/bin/text-embeddings-router

ENTRYPOINT ["text-embeddings-router"]
CMD ["--json-output"]

FROM base AS http

COPY --from=http-builder /usr/src/text-embeddings-inference/target/release/text-embeddings-router /usr/local/bin/text-embeddings-router

# Amazon SageMaker compatible image
FROM http AS sagemaker
COPY --chmod=775 sagemaker-entrypoint.sh entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

# Default image
FROM http

ENTRYPOINT ["text-embeddings-router"]
CMD ["--json-output"]
