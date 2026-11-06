FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.1.5
ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

LABEL author="openEuler CloudNative SIG" description="VBench with Ascend NPU support (torch_npu + CANN)"

RUN pip config set global.index-url ${PIP_INDEX_URL}

# rust/cargo build the tokenizers sdist pinned by upstream (transformers==4.33.2);
# PYO3_USE_ABI3_FORWARD_COMPATIBILITY lets its pyo3 0.18 backend target Python 3.12
ENV PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1

# Build Decord 0.6.0 from source (no aarch64 wheel is published)
RUN dnf install -y ffmpeg-devel rust cargo && \
    dnf clean all && \
    git clone --recursive --depth 1 --branch v0.6.0 https://github.com/dmlc/decord.git /tmp/decord && \
    cmake -S /tmp/decord -B /tmp/decord/build -DUSE_CUDA=OFF -DCMAKE_BUILD_TYPE=Release && \
    cmake --build /tmp/decord/build --parallel $(nproc) && \
    python3 -m pip install --no-cache-dir --no-build-isolation --no-deps /tmp/decord/python && \
    rm -rf /tmp/decord

# Install VBench; torchvision is pinned to the version matching torch 2.9.0 in the base image
RUN python3 -m pip install --no-cache-dir vbench==${VERSION} torchvision==0.24.0 gdown==6.4.2 && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
