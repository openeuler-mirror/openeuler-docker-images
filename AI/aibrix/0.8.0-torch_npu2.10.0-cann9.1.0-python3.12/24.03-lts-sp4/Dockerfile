FROM quay.io/ascend/torch-npu:2.10.0.post6-cann9.1.0-910b-openeuler24.03-py3.12

# Use PyPI directly; the base image pip.conf points at a mirror that is
# unreachable from the CI builders.
ENV PIP_INDEX_URL=https://pypi.org/simple

# Harden git against the flaky CI network (force HTTP/1.1, large post buffer).
ENV GIT_CONFIG_COUNT=2 \
    GIT_CONFIG_KEY_0=http.version \
    GIT_CONFIG_VALUE_0=HTTP/1.1 \
    GIT_CONFIG_KEY_1=http.postBuffer \
    GIT_CONFIG_VALUE_1=524288000

ARG VERSION=0.8.0

LABEL author="openEuler CloudNative SIG" description="AIBrix local mode inference backend (vLLM-Ascend) with Ascend NPU support (torch_npu + CANN)"


# Install the vLLM-Ascend inference backend stack used by the AIBrix Ascend
# quick start: vllm first, then vllm-ascend pins the torch/torch_npu 2.10.0
# pairing, then triton-ascend is forced back over the community triton
# The PyPI vllm wheel pins torch==2.11.0 and pulls CUDA-only extras
# (flashinfer, humming-kernels, ...), which conflicts with the torch_npu
# 2.10 stack of the base image. Install the vllm/vllm-ascend wheels without
# dependencies, force the Ascend triton backend, then install the filtered
# runtime dependency set (the same pattern the vllm-ascend upstream images use).
RUN python3 -m pip install --no-cache-dir --no-deps vllm==0.23.0 vllm-ascend==0.23.0 && \
    python3 -m pip install --no-cache-dir --force-reinstall --no-deps \
        --extra-index-url https://triton-ascend.osinfra.cn/pypi/simple \
        triton-ascend==3.2.2

RUN python3 -m pip install --no-cache-dir packaging

RUN python3 - <<'PY'
from importlib.metadata import requires
from pathlib import Path
from packaging.requirements import Requirement
from packaging.utils import canonicalize_name

managed = {"torch", "torch-npu", "torchvision", "torchaudio", "triton", "triton-ascend", "vllm", "vllm-ascend", "transformers"}
cuda_only = {"flashinfer-python", "flashinfer-cubin", "flash-attn", "humming-kernels", "quack-kernels", "tokenspeed-mla", "tilelang", "fastsafetensors", "helion", "nvidia-cutlass-dsl", "nvidia-cutlass-dsl-libs-base", "nvidia-cutlass-dsl-libs-core", "nvidia-cutlass-dsl-libs-cu12"}
selected = []
for package in ("vllm", "vllm-ascend"):
    for value in requires(package) or []:
        requirement = Requirement(value)
        if requirement.marker and not requirement.marker.evaluate({"extra": ""}):
            continue
        name = canonicalize_name(requirement.name)
        if name in managed or name in cuda_only or name.startswith("nvidia-"):
            continue
        if name == "mistral-common":
            requirement.extras.discard("image")
        selected.append(str(requirement))
selected += ["transformers==5.5.4"]
Path("/tmp/vllm-npu-deps.txt").write_text("\n".join(sorted(set(selected))) + "\n", encoding="utf-8")
PY

RUN printf 'torch==2.10.0\ntorchvision==0.25.0\ntorchaudio==2.10.0\ntorch-npu==2.10.0.post6\n' > /opt/vllm-npu-constraints.txt && \
    PIP_CONSTRAINT=/opt/vllm-npu-constraints.txt python3 -m pip install --no-cache-dir -r /tmp/vllm-npu-deps.txt modelscope==1.31.0 && \
    python3 -m pip cache purge

# AIBrix release source for the local mode deployment scripts (the Go gateway
# and Envoy are installed separately following the upstream quick start)
RUN dnf install -y git && dnf clean all && \
    git clone --depth 1 --branch v${VERSION} https://github.com/vllm-project/aibrix.git /opt/aibrix

CMD ["/bin/bash"]
