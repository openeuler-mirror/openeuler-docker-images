FROM quay.io/ascend/torch-npu:2.10.0.post6-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.8.0
ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

LABEL author="openEuler CloudNative SIG" description="AIBrix local mode inference backend (vLLM-Ascend) with Ascend NPU support (torch_npu + CANN)"

RUN pip config set global.index-url ${PIP_INDEX_URL}

# Install the vLLM-Ascend inference backend stack used by the AIBrix Ascend
# quick start: vllm first, then vllm-ascend pins the torch/torch_npu 2.10.0
# pairing, then triton-ascend is forced back over the community triton
RUN python3 -m pip install --no-cache-dir vllm==0.23.0 && \
    python3 -m pip install --no-cache-dir \
        --extra-index-url https://mirrors.huaweicloud.com/ascend/repos/pypi/variant \
        --extra-index-url https://mirrors.huaweicloud.com/ascend/repos/pypi \
        vllm-ascend==0.23.0 modelscope==1.31.0 && \
    python3 -m pip install --no-cache-dir --force-reinstall --no-deps \
        --extra-index-url https://mirrors.huaweicloud.com/ascend/repos/pypi \
        triton-ascend==3.2.2 && \
    python3 -m pip cache purge

# AIBrix release source for the local mode deployment scripts (the Go gateway
# and Envoy are installed separately following the upstream quick start)
RUN dnf install -y git && dnf clean all && \
    git clone --depth 1 --branch v${VERSION} https://github.com/vllm-project/aibrix.git /opt/aibrix

CMD ["/bin/bash"]
