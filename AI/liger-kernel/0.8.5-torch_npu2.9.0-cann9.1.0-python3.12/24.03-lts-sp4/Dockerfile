FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.8.5
ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

LABEL author="openEuler CloudNative SIG" description="Liger Kernel (LinkedIn) with Ascend NPU support (triton-ascend + torch_npu + CANN)"

RUN pip config set global.index-url ${PIP_INDEX_URL}

# Install the Ascend Triton fork first, then Liger Kernel with --no-deps so
# pip never installs a PyPI triton/torch over the torch_npu stack
RUN python3 -m pip install --no-cache-dir triton-ascend==3.2.2 \
        --extra-index-url https://triton-ascend.osinfra.cn/pypi/simple \
        --trusted-host triton-ascend.osinfra.cn && \
    python3 -m pip install --no-cache-dir transformers && \
    python3 -m pip install --no-cache-dir --no-deps liger-kernel==${VERSION} && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
