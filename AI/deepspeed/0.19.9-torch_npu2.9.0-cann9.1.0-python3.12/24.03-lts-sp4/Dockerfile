FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.19.9
ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

LABEL author="openEuler CloudNative SIG" description="DeepSpeed with Ascend NPU support (torch_npu + CANN)"

RUN pip config set global.index-url ${PIP_INDEX_URL}

# Install DeepSpeed and the torchvision build matching the preinstalled torch,
# so pip does not replace the NPU torch stack
RUN python3 -m pip install --no-cache-dir deepspeed==${VERSION} "torchvision==0.24.*" && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
