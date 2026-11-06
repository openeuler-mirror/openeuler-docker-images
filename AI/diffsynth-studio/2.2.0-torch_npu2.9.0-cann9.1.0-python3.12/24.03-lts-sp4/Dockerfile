FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=2.2.0
ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

LABEL author="openEuler CloudNative SIG" description="DiffSynth-Studio with Ascend NPU support (torch_npu + CANN)"

RUN pip config set global.index-url ${PIP_INDEX_URL}

# Install the diffsynth package from PyPI without the npu_aarch64 extra, so the torch 2.9.0 + torch_npu 2.9.0.post8 stack of the base image is kept
RUN python3 -m pip install --no-cache-dir torchvision==0.24.0 diffsynth==${VERSION} && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
