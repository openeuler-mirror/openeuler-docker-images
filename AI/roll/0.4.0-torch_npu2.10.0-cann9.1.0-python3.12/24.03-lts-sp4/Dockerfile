FROM quay.io/ascend/torch-npu:2.10.0.post6-cann9.1.0-910b-openeuler24.03-py3.12

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

ARG VERSION=0.4.0
ARG ASCEND_PIP_INDEX="https://repo.huaweicloud.com/ascend/repos/pypi"

LABEL author="openEuler CloudNative SIG" description="Alibaba ROLL RL training framework with Ascend NPU support (torch_npu + CANN)"


RUN dnf -y install --nodocs --setopt=install_weak_deps=False git && dnf clean all

# NPU constraints that keep the preinstalled torch/torch_npu stack untouched
RUN printf 'numpy==1.26.4\nscipy==1.16.3\npyarrow==20.0.0\npandas==2.2.3\ntorch==2.10.0\ntorchvision==0.25.0\ntorchaudio==2.10.0\ntorch-npu==2.10.0.post6\ntransformers==4.57.6\nopencv-python-headless==4.11.0.86\n' > /opt/roll-npu-constraints.txt

# Install ROLL from the release source and its FSDP2/vLLM path dependencies
RUN git clone --depth 1 --branch v${VERSION} https://github.com/alibaba/ROLL.git /opt/ROLL && \
    cd /opt/ROLL && \
    grep -vE '^[[:space:]]*gem-llm|\./mcore_adapter|requirements_vision\.txt' requirements_common.txt > .ci-requirements-common.txt && \
    PIP_CONSTRAINT=/opt/roll-npu-constraints.txt python3 -m pip install --no-cache-dir --no-deps --no-build-isolation -e . && \
    PIP_CONSTRAINT=/opt/roll-npu-constraints.txt python3 -m pip install --no-cache-dir -r .ci-requirements-common.txt && \
    PIP_CONSTRAINT=/opt/roll-npu-constraints.txt python3 -m pip install --no-cache-dir --ignore-requires-python --no-deps 'gem-llm==0.0.4' && \
    PIP_CONSTRAINT=/opt/roll-npu-constraints.txt python3 -m pip install --no-cache-dir \
        'numpy==1.26.4' 'scipy==1.16.3' 'transformers==4.57.6' 'tensorboard==2.20.0' \
        'antlr4-python3-runtime==4.9.3' 'modelscope==1.37.0' 'reasoning-gym==0.1.23' \
        'gym_sokoban' 'gymnasium[toy-text]' 'packaging==25.0' && \
    python3 -m pip cache purge

# Install the vLLM-Ascend rollout stack matched to torch 2.10 (never resolve the CUDA dependency graph)
RUN python3 -m pip install --no-cache-dir --no-deps 'vllm==0.23.0' 'vllm-ascend==0.23.0rc1' && \
    printf '%s\n' \
        'from importlib.metadata import requires' \
        'from pathlib import Path' \
        'from packaging.requirements import Requirement' \
        'from packaging.utils import canonicalize_name' \
        '' \
        'managed = {"torch", "torch-npu", "torchvision", "torchaudio", "triton", "triton-ascend", "vllm", "transformers"}' \
        'cuda_only = {"flashinfer-python", "flashinfer-cubin", "flash-attn", "humming-kernels", "quack-kernels", "tokenspeed-mla", "tilelang", "fastsafetensors", "helion"}' \
        'selected = []' \
        'for package in ("vllm", "vllm-ascend"):' \
        '    for value in requires(package) or []:' \
        '        requirement = Requirement(value)' \
        '        if requirement.marker and not requirement.marker.evaluate({"extra": ""}):' \
        '            continue' \
        '        name = canonicalize_name(requirement.name)' \
        '        if name in managed or name in cuda_only or name.startswith("nvidia-"):' \
        '            continue' \
        '        if name == "opencv-python-headless":' \
        '            requirement = Requirement("opencv-python-headless==4.11.0.86")' \
        '        elif name == "mistral-common":' \
        '            requirement.extras.discard("image")' \
        '        selected.append(str(requirement))' \
        'selected += ["transformers==4.57.6", "scipy==1.16.3", "opencv-python-headless==4.11.0.86"]' \
        'Path("/tmp/vllm-npu-deps.txt").write_text("\n".join(sorted(set(selected))) + "\n", encoding="utf-8")' \
        > /tmp/vllm-npu-filter.py && \
    python3 /tmp/vllm-npu-filter.py && \
    PIP_CONSTRAINT=/opt/roll-npu-constraints.txt python3 -m pip install --no-cache-dir -r /tmp/vllm-npu-deps.txt && \
    python3 -m pip uninstall -y -q triton triton-ascend || true && \
    python3 -m pip install --no-cache-dir 'triton==3.5.0' && \
    python3 -m pip install --no-cache-dir --no-deps --index-url ${ASCEND_PIP_INDEX} 'triton-ascend==3.2.1' && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
