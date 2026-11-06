FROM quay.io/ascend/torch-npu:2.10.0.post7-cann9.2.0-910b-openeuler24.03-py3.12

ARG VERSION=0.6.0
ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

LABEL author="openEuler CloudNative SIG" description="Flash Linear Attention with Ascend NPU support (torch_npu + Triton-Ascend + CANN)"

RUN pip config set global.index-url ${PIP_INDEX_URL}

# Install the Triton-Ascend backend first (no-deps keeps the NPU stack intact), then flash-linear-attention with its [npu] extra
RUN python3 -m pip install --no-cache-dir --no-deps \
        --extra-index-url https://triton-ascend.osinfra.cn/pypi/simple \
        triton-ascend==3.6.0 && \
    python3 -m pip install --no-cache-dir \
        --extra-index-url https://triton-ascend.osinfra.cn/pypi/simple \
        "flash-linear-attention[npu]==${VERSION}" && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
