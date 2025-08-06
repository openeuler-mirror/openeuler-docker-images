ARG BASE=openeuler/openeuler:24.03-lts
ARG VERSION=v1.7.0

FROM $BASE AS chef

RUN yum update -y && \
    yum install -y \
        unzip \
        wget \
        gcc \
        git && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init && \
    chmod +x rustup-init && \
    ./rustup-init -y && \
    rm rustup-init
ENV PATH="/root/.cargo/bin:$PATH"
RUN cargo install cargo-chef --locked

WORKDIR /usr/src

ENV SCCACHE=0.5.4
ENV RUSTC_WRAPPER=/usr/local/bin/sccache

# Donwload, configure sccache
RUN curl -fsSL https://github.com/mozilla/sccache/releases/download/v$SCCACHE/sccache-v$SCCACHE-x86_64-unknown-linux-musl.tar.gz | tar -xzv --strip-components=1 -C /usr/local/bin sccache-v$SCCACHE-x86_64-unknown-linux-musl/sccache && \
    chmod +x /usr/local/bin/sccache

FROM chef AS planner

ARG VERSION
ARG TEI_REPO=https://github.com/huggingface/text-embeddings-inference.git
RUN git clone -b $VERSION $TEI_REPO && \
    cp -r text-embeddings-inference/candle-extensions candle-extensions && \
    cp -r text-embeddings-inference/backends backends && \
    cp -r text-embeddings-inference/core core && \
    cp -r text-embeddings-inference/router router && \
    cp -r text-embeddings-inference/Cargo.toml Cargo.toml && \
    cp -r text-embeddings-inference/Cargo.lock Cargo.lock && \
    rm -rf text-embeddings-inference

RUN cargo chef prepare  --recipe-path recipe.json

FROM chef AS builder

ARG GIT_SHA
ARG DOCKER_LABEL

# sccache specific variables
ARG SCCACHE_GHA_ENABLED

RUN yum update -y && \
    yum install -y \
        libnotify \
        libxcb \
        gtk3 \
        libdrm \
        nss \
        at-spi2-core \
        mesa-libgbm \
        xdg-utils \
        g++ && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN wget -q https://registrationcenter-download.intel.com/akdlm/IRC_NAS/bd1d0273-a931-4f7e-ab76-6a2a67d646c7/intel-oneapi-base-toolkit-2025.2.0.592_offline.sh && \
    chmod +x intel-oneapi-base-toolkit-2025.2.0.592_offline.sh && \
    ./intel-oneapi-base-toolkit-2025.2.0.592_offline.sh -a -s --eula accept --install-dir /opt/intel/oneapi && \
    rm intel-oneapi-base-toolkit-2025.2.0.592_offline.sh

RUN yum update -y && \
    yum install -y \
        gcc g++ make cmake \
        openssl-devel && \
    rm -rf /var/yum/cache

RUN echo "int mkl_serv_intel_cpu_true() {return 1;}" > fakeintel.c && \
    gcc -shared -fPIC -o libfakeintel.so fakeintel.c

COPY --from=planner /usr/src/recipe.json recipe.json

RUN cargo chef cook --release --features ort,candle,mkl --no-default-features --recipe-path recipe.json && sccache -s

# remember to clean up before copying the source code
ARG VERSION
ARG TEI_REPO=https://github.com/huggingface/text-embeddings-inference.git
RUN git clone -b $VERSION $TEI_REPO && \
    rm -fr backends && cp -r text-embeddings-inference/backends backends && \
    rm -fr core && cp -r text-embeddings-inference/core core && \
    rm -fr router && cp -r text-embeddings-inference/router router && \
    cp -r text-embeddings-inference/Cargo.toml Cargo.toml && \
    cp -r text-embeddings-inference/Cargo.lock Cargo.lock && \
    rm -rf text-embeddings-inference

FROM builder AS http-builder

RUN cargo build --release --bin text-embeddings-router --features ort,candle,mkl,http --no-default-features && sccache -s

FROM builder AS grpc-builder

RUN PROTOC_ZIP=protoc-21.12-linux-x86_64.zip && \
    curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v21.12/$PROTOC_ZIP && \
    unzip -o $PROTOC_ZIP -d /usr/local bin/protoc && \
    unzip -o $PROTOC_ZIP -d /usr/local 'include/*' && \
    rm -f $PROTOC_ZIP

ARG VERSION
ARG TEI_REPO=https://github.com/huggingface/text-embeddings-inference.git
RUN git clone -b $VERSION $TEI_REPO && \
    cp -r text-embeddings-inference/proto proto && \
    rm -rf text-embeddings-inference

RUN cargo build --release --bin text-embeddings-router --features ort,candle,mkl,grpc --no-default-features && sccache -s

ARG BASE 
FROM $BASE AS base

ENV HUGGINGFACE_HUB_CACHE=/data \
    PORT=80 \
    MKL_ENABLE_INSTRUCTIONS=AVX512_E4 \
    RAYON_NUM_THREADS=8 \
    LD_PRELOAD=/usr/local/libfakeintel.so \
    LD_LIBRARY_PATH=/usr/local/lib

RUN yum update -y && \
    yum install -y \
        libomp-devel \
        ca-certificates \
        openssl-devel \
        curl \
    && rm -rf /var/yum/cache

# Copy a lot of the Intel shared objects because of the mkl_serv_intel_cpu_true patch...
COPY --from=builder /opt/intel/oneapi/mkl/latest/lib/intel64/libmkl_intel_lp64.so.2 /usr/local/lib/libmkl_intel_lp64.so.2
COPY --from=builder /opt/intel/oneapi/mkl/latest/lib/intel64/libmkl_intel_thread.so.2 /usr/local/lib/libmkl_intel_thread.so.2
COPY --from=builder /opt/intel/oneapi/mkl/latest/lib/intel64/libmkl_core.so.2 /usr/local/lib/libmkl_core.so.2
COPY --from=builder /opt/intel/oneapi/mkl/latest/lib/intel64/libmkl_vml_def.so.2 /usr/local/lib/libmkl_vml_def.so.2
COPY --from=builder /opt/intel/oneapi/mkl/latest/lib/intel64/libmkl_def.so.2 /usr/local/lib/libmkl_def.so.2
COPY --from=builder /opt/intel/oneapi/mkl/latest/lib/intel64/libmkl_vml_avx2.so.2 /usr/local/lib/libmkl_vml_avx2.so.2
COPY --from=builder /opt/intel/oneapi/mkl/latest/lib/intel64/libmkl_vml_avx512.so.2 /usr/local/lib/libmkl_vml_avx512.so.2
COPY --from=builder /opt/intel/oneapi/mkl/latest/lib/intel64/libmkl_avx2.so.2 /usr/local/lib/libmkl_avx2.so.2
COPY --from=builder /opt/intel/oneapi/mkl/latest/lib/intel64/libmkl_avx512.so.2 /usr/local/lib/libmkl_avx512.so.2
COPY --from=builder /usr/src/libfakeintel.so /usr/local/libfakeintel.so
COPY --from=builder /opt/intel/oneapi/2025.2/lib/libiomp5.so /usr/lib64/libiomp5.so

FROM base AS grpc

COPY --from=grpc-builder /usr/src/target/release/text-embeddings-router /usr/local/bin/text-embeddings-router

ENTRYPOINT ["text-embeddings-router"]
CMD ["--json-output"]

FROM base AS http

COPY --from=http-builder /usr/src/target/release/text-embeddings-router /usr/local/bin/text-embeddings-router

# Amazon SageMaker compatible image
FROM http AS sagemaker
COPY --chmod=775 sagemaker-entrypoint.sh entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

# Default image
FROM http

ENTRYPOINT ["text-embeddings-router"]
CMD ["--json-output"]