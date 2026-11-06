FROM quay.io/ascend/torch-npu:2.10.0.post6-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.9.0
ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

LABEL author="openEuler CloudNative SIG" description="Speculators (speculative decoding framework) with Ascend NPU support (vLLM-Ascend + torch_npu + CANN)"

RUN pip config set global.index-url ${PIP_INDEX_URL}

# Install the vLLM-Ascend stack used by the speculators Ascend quick start:
# vllm first, then vllm-ascend pins the torch/torch_npu 2.10.0 pairing and
# transformers 5.5.4, then triton-ascend is forced back over the community
# triton, and numpy is pinned for triton-ascend compatibility
RUN python3 -m pip install --no-cache-dir vllm==0.23.0 && \
    python3 -m pip install --no-cache-dir \
        --extra-index-url https://mirrors.huaweicloud.com/ascend/repos/pypi/variant \
        --extra-index-url https://mirrors.huaweicloud.com/ascend/repos/pypi \
        vllm-ascend==0.23.0 modelscope==1.37.0 && \
    python3 -m pip install --no-cache-dir --force-reinstall --no-deps \
        --extra-index-url https://mirrors.huaweicloud.com/ascend/repos/pypi \
        triton-ascend==3.2.2 && \
    python3 -m pip install --no-cache-dir "numpy==1.26.4" "setuptools>=77,<81" && \
    python3 -m pip cache purge

# Install speculators from the release source: the wheel with --no-deps (the
# NPU stack must not be re-resolved), the in-tree hs_connectors package needed
# by speculators.train, and the explicit dependency list of the quick start
RUN dnf install -y git && dnf clean all && \
    git clone --depth 1 --branch v${VERSION} https://github.com/vllm-project/speculators.git /opt/speculators && \
    python3 -m pip install --no-cache-dir --no-deps /opt/speculators && \
    python3 -m pip install --no-cache-dir --no-deps /opt/speculators/hs_connectors && \
    python3 -m pip install --no-cache-dir aiohttp click "datasets>=4.0.0,<=5.0.1" httpx huggingface-hub \
        "loguru>=0.7.2,<=0.7.3" openai protobuf psutil "pydantic>=2.0.0" "pydantic-settings>=2.0.0" \
        rich safetensors "tqdm>=4.66.3,<=4.70.0" "typer>=0.12.0" && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
