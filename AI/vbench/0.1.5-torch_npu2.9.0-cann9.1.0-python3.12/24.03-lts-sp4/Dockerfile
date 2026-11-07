FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

# Use PyPI directly; the base image pip.conf points at a mirror that is
# unreachable from the CI builders.
ENV PIP_INDEX_URL=https://pypi.org/simple

# Harden git against the flaky CI network (HTTP/2 resets, stalled transfers).
ENV GIT_CONFIG_COUNT=4 \
    GIT_CONFIG_KEY_0=http.version \
    GIT_CONFIG_VALUE_0=HTTP/1.1 \
    GIT_CONFIG_KEY_1=http.postBuffer \
    GIT_CONFIG_VALUE_1=524288000 \
    GIT_CONFIG_KEY_2=http.lowSpeedLimit \
    GIT_CONFIG_VALUE_2=1000 \
    GIT_CONFIG_KEY_3=http.lowSpeedTime \
    GIT_CONFIG_VALUE_3=60

ARG VERSION=0.1.5

LABEL author="openEuler CloudNative SIG" description="VBench with Ascend NPU support (torch_npu + CANN)"


# rust/cargo build the tokenizers sdist pinned by upstream (transformers==4.33.2);
# PYO3_USE_ABI3_FORWARD_COMPATIBILITY lets its pyo3 0.18 backend target Python 3.12
ENV PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1

# Build Decord 0.6.0 from source (no aarch64 wheel is published)
RUN dnf install -y ffmpeg-devel rust cargo && \
    dnf clean all && \
    git clone --recursive --depth 1 --branch v0.6.0 https://github.com/dmlc/decord.git /tmp/decord && \
    sed -i 's|#include <libavcodec/avcodec.h>|#include <libavcodec/avcodec.h>\n#include <libavcodec/bsf.h>|' /tmp/decord/src/video/ffmpeg/ffmpeg_common.h && \
    cmake -S /tmp/decord -B /tmp/decord/build -DUSE_CUDA=OFF -DCMAKE_BUILD_TYPE=Release && \
    cmake --build /tmp/decord/build --parallel $(nproc) && \
    python3 -m pip install --no-cache-dir --no-build-isolation --no-deps /tmp/decord/python && \
    rm -rf /tmp/decord

# Install VBench; torchvision is pinned to the version matching torch 2.9.0 in the base image
RUN python3 -m pip install --no-cache-dir vbench==${VERSION} torchvision==0.24.0 gdown==6.4.2 && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
