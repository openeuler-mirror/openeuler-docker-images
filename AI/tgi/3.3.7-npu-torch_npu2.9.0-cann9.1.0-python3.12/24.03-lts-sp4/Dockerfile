FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=3.3.7-npu
ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

LABEL author="openEuler CloudNative SIG" description="Text Generation Inference (TGI) with Ascend NPU support (torch_npu + CANN)"

RUN pip config set global.index-url ${PIP_INDEX_URL}

# System dependencies (Rust + Python dual-stack build)
RUN yum install -y gcc gcc-c++ make protobuf-compiler pkg-config openssl-devel git curl && \
    yum clean all && \
    rm -rf /var/cache/yum

# Rust toolchain pinned by the repo's rust-toolchain.toml, via the rsproxy.cn mirror
ENV RUSTUP_DIST_SERVER=https://rsproxy.cn
ENV RUSTUP_UPDATE_ROOT=https://rsproxy.cn/rustup
RUN curl -fsSL https://rsproxy.cn/rustup-init.sh -o /tmp/rustup-init.sh && \
    sh /tmp/rustup-init.sh -y --default-toolchain 1.85.1 --profile minimal && \
    rm -f /tmp/rustup-init.sh && \
    mkdir -p /root/.cargo && \
    printf '[source.crates-io]\nreplace-with = "rsproxy-sparse"\n[source.rsproxy-sparse]\nregistry = "sparse+https://rsproxy.cn/index/"\n' \
        > /root/.cargo/config.toml

ENV PATH=/root/.cargo/bin:$PATH
ENV UV_SYSTEM_PYTHON=1

# Fetch the sources of the Ascend-adapted fork (release tag on feat/ascend-npu)
RUN git clone --branch "v${VERSION}" --depth 1 \
        https://github.com/VenusTZZ/text-generation-inference.git /opt/text-generation-inference

# Python dependencies (torch and torch_npu are provided by the base image)
# kernels must stay at 0.5.0: it is the build backend of the Python server and
# ships the kernels.lockfile that avoids CUDA-only kernel downloads.
RUN python3 -m pip install --no-cache-dir uv && \
    uv pip install --index-url ${PIP_INDEX_URL} \
        "transformers==4.57.6" "accelerate==1.15.0" "modelscope==1.37.0" \
        "kernels==0.5.0" "grpcio-tools>=1.69.0" "mypy-protobuf>=3.6.0" && \
    python3 -m pip cache purge

# Build the Rust launcher and router
RUN cd /opt/text-generation-inference && \
    export PYO3_PYTHON="$(command -v python3)" && \
    export PROTOC="$(command -v protoc)" && \
    cargo build --profile release-opt \
        -p text-generation-launcher -p text-generation-router-v3 && \
    install -m 755 target/release-opt/text-generation-launcher /usr/local/bin/ && \
    install -m 755 target/release-opt/text-generation-router /usr/local/bin/ && \
    rm -rf target

# Install the Python server (editable, sources are kept in the image)
RUN cd /opt/text-generation-inference && \
    uv pip install --index-url ${PIP_INDEX_URL} --no-build-isolation -e server && \
    make -C server gen-server-raw && \
    rm -rf /root/.cargo /root/.rustup /root/.cache/uv && \
    python3 -m pip cache purge

# NPU serving defaults (torch-npu attention; prefix caching is not supported yet)
ENV ATTENTION=flashdecoding-npu
ENV PREFIX_CACHING=0
ENV PREFILL_CHUNKING=1
ENV CUDA_GRAPHS=0
ENV HCCL_CONNECT_TIMEOUT=1800

CMD ["/bin/bash"]
