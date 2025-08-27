ARG BASE=openeuler/openeuler:24.03-lts
ARG VERSION=v2.4.0

ARG PLATFORM=cpu

# Rust builder
FROM lukemathwalker/cargo-chef:latest-rust-1.80.1 AS chef
WORKDIR /usr/src

ARG CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse

FROM chef AS planner

ARG VERSION 
ARG TGI_REPO=https://github.com/huggingface/text-generation-inference.git
RUN git clone -b $VERSION $TGI_REPO && \
    cp -r text-generation-inference/Cargo.toml Cargo.toml && \
    cp -r text-generation-inference/Cargo.lock Cargo.lock && \
    cp -r text-generation-inference/rust-toolchain.toml rust-toolchain.toml && \
    cp -r text-generation-inference/proto proto && \
    cp -r text-generation-inference/backends backends && \
    cp -r text-generation-inference/benchmark benchmark && \
    cp -r text-generation-inference/launcher launcher && \
    cp -r text-generation-inference/router router && \
    rm -rf text-generation-inference

RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3.11-dev

RUN PROTOC_ZIP=protoc-21.12-linux-x86_64.zip && \
    curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v21.12/$PROTOC_ZIP && \
    unzip -o $PROTOC_ZIP -d /usr/local bin/protoc && \
    unzip -o $PROTOC_ZIP -d /usr/local 'include/*' && \
    rm -f $PROTOC_ZIP

COPY --from=planner /usr/src/recipe.json recipe.json
RUN cargo chef cook --profile release-opt --recipe-path recipe.json

ARG GIT_SHA
ARG DOCKER_LABEL

COPY --from=planner /usr/src/Cargo.lock Cargo.lock
COPY --from=planner /usr/src/Cargo.toml Cargo.toml
COPY --from=planner /usr/src/rust-toolchain.toml rust-toolchain.toml
COPY --from=planner /usr/src/proto proto
COPY --from=planner /usr/src/benchmark benchmark
COPY --from=planner /usr/src/router router
COPY --from=planner /usr/src/backends backends
COPY --from=planner /usr/src/launcher launcher

RUN cargo build --profile release-opt --frozen

ARG BASE 

FROM $BASE AS cpu

RUN yum update -y && \
    yum install -y \
        curl \
        ca-certificates \
        make \
        g++ \
        gcc \
        git \
        wget \
        cmake \
        numactl-devel \
        numactl-libs && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 12
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 12
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30
RUN update-alternatives --set cc /usr/bin/gcc

RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
RUN update-alternatives --set c++ /usr/bin/g++


ENV HUGGINGFACE_HUB_CACHE=/data \
    HF_HUB_ENABLE_HF_TRANSFER=1 \
    PORT=80

ARG MAMBA_VERSION=23.1.0-1
ARG PYTHON_VERSION='3.11.10'
# Automatically set by buildx
ARG TARGETPLATFORM
ENV PATH /opt/conda/bin:$PATH

# TGI seem to require libssl.so.1.1 instead of libssl.so.3 so we can't use ubuntu 22.04. Ubuntu 20.04 has python==3.8, and TGI requires python>=3.9, hence the need for miniconda.
# Install mamba
# translating Docker's TARGETPLATFORM into mamba arches
RUN case ${TARGETPLATFORM} in \
         "linux/arm64")  MAMBA_ARCH=aarch64  ;; \
         *)              MAMBA_ARCH=x86_64   ;; \
    esac && \
    curl -fsSL -v -o ~/mambaforge.sh -O  "https://github.com/conda-forge/miniforge/releases/download/${MAMBA_VERSION}/Mambaforge-${MAMBA_VERSION}-Linux-${MAMBA_ARCH}.sh"
RUN chmod +x ~/mambaforge.sh && \
    bash ~/mambaforge.sh -b -p /opt/conda && \
    rm ~/mambaforge.sh

RUN case ${TARGETPLATFORM} in \
         "linux/arm64")  exit 1 ;; \
         *)              /opt/conda/bin/conda update -y conda &&  \
                         /opt/conda/bin/conda install -y "python=${PYTHON_VERSION}" ;; \
    esac && \
    /opt/conda/bin/conda clean -ya

RUN conda install -c conda-forge gperftools mkl


RUN pip install https://download.pytorch.org/whl/nightly/cpu/torch-2.5.0.dev20240815%2Bcpu-cp311-cp311-linux_x86_64.whl
RUN pip install https://download.pytorch.org/whl/nightly/cpu/torchvision-0.20.0.dev20240815%2Bcpu-cp311-cp311-linux_x86_64.whl
RUN pip install https://download.pytorch.org/whl/nightly/cpu/torchaudio-2.4.0.dev20240815%2Bcpu-cp311-cp311-linux_x86_64.whl

RUN pip install triton py-libnuma

WORKDIR /usr/src

RUN git clone https://github.com/intel/intel-extension-for-pytorch && cd intel-extension-for-pytorch && git checkout f86e93e4890dc2c989024d148d415c9aa8a1649f
RUN git clone https://github.com/intel/torch-ccl.git && cd torch-ccl && git checkout v2.4.0+cpu+rc0

RUN cd intel-extension-for-pytorch && git submodule sync && git submodule update --init --recursive && python setup.py install

RUN cd torch-ccl && git submodule sync && git submodule update --init --recursive && pip install .

ENV LD_PRELOAD=/opt/conda/lib/libtcmalloc.so
ENV CCL_ROOT=/opt/conda/lib/python3.11/site-packages/oneccl_bindings_for_pytorch
ENV I_MPI_ROOT=/opt/conda/lib/python3.11/site-packages/oneccl_bindings_for_pytorch
ENV FI_PROVIDER_PATH=/opt/conda/lib/python3.11/site-packages/oneccl_bindings_for_pytorch/opt/mpi/libfabric/lib/prov:/usr/lib64/libfabric
ENV LD_LIBRARY_PATH=/opt/conda/lib/python3.11/site-packages/oneccl_bindings_for_pytorch/opt/mpi/libfabric/lib:/opt/conda/lib/python3.11/site-packages/oneccl_bindings_for_pytorch/lib
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/conda/lib/"

# Install server
ARG VERSION
ARG TGI_REPO=https://github.com/huggingface/text-generation-inference.git
RUN git clone -b $VERSION $TGI_REPO && \
    rm -fr proto && cp -r text-generation-inference/proto proto && \
    rm -fr server && cp -r text-generation-inference/server server && \
    cp -r text-generation-inference/server/Makefile server/Makefile

RUN cd server && \
    make gen-server && \
    pip install -r requirements_intel.txt && \
    pip install ".[accelerate, peft, outlines]" --no-cache-dir

# Install benchmarker
COPY --from=builder /usr/src/target/release-opt/text-generation-benchmark /usr/local/bin/text-generation-benchmark
# Install router
COPY --from=builder /usr/src/target/release-opt/text-generation-router /usr/local/bin/text-generation-router
# Install launcher
COPY --from=builder /usr/src/target/release-opt/text-generation-launcher /usr/local/bin/text-generation-launcher

FROM ${PLATFORM} AS final
ENV ATTENTION=paged
ENV PREFIX_CACHING=0
ENV PREFILL_CHUNKING=0
ENV CUDA_GRAPHS=0
ENTRYPOINT ["text-generation-launcher"]
CMD ["--json-output"]