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

ARG VERSION=0.9.0

LABEL author="openEuler CloudNative SIG" description="Speculators (speculative decoding framework) with Ascend NPU support (vLLM-Ascend + torch_npu + CANN)"


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

# numpy 2 is what the upstream stack targets: speculators 0.9.0 itself
# declares numpy>=2.0.0,<=2.5.4, and vllm 0.23.0 requires
# opencv-python-headless>=4.13.0, whose releases all require numpy>=2 on
# Python >=3.9 (only opencv <=4.11 supports numpy 1.x). Pinning numpy 1.26.4
# therefore made every opencv candidate unsatisfiable.
RUN printf 'torch==2.10.0\ntorchvision==0.25.0\ntorchaudio==2.10.0\ntorch-npu==2.10.0.post6\n' > /opt/vllm-npu-constraints.txt && \
    PIP_CONSTRAINT=/opt/vllm-npu-constraints.txt python3 -m pip install --no-cache-dir -r /tmp/vllm-npu-deps.txt modelscope==1.37.0 "numpy>=2.0.0,<=2.5.4" "setuptools>=77,<81" && \
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
