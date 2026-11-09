# verl Ascend A2 image on openEuler, ported from the upstream
# docker/ascend/Dockerfile.ascend_9.1.0_a2 of the verl project.
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

ARG SOC_VERSION="ascend910b1"

# Pinned upstream references (tags / commits) so that one image tag always
# rebuilds the exact same software stack.
ARG VERL_REF=a911bca25d6adb26f5bef2dc57e7ba62e99b7ade

# Keep the build layout aligned with the upstream Dockerfile (repositories are
# cloned under /).
WORKDIR /

LABEL author="openEuler CloudNative SIG" description="verl RL training framework with Ascend NPU support (torch_npu + CANN + vLLM-Ascend + Megatron)"

# Prepare required system dependencies
RUN dnf -y install --nodocs --setopt=install_weak_deps=False \
        gcc gcc-c++ make cmake numactl-devel git tar && \
    dnf clean all && \
    rm -rf /var/cache/dnf /tmp/* /var/tmp/* && \
    pip install --upgrade pip packaging setuptools==80.10.2 && \
    pip cache purge

# NPU constraints that keep the preinstalled torch/torch_npu stack untouched
RUN printf 'torch==2.10.0\ntorchvision==0.25.0\ntorchaudio==2.10.0\ntorch-npu==2.10.0.post7\n' > /opt/verl-npu-constraints.txt

# Clone the Megatron/MindSpeed training stack with every reference pinned
RUN git clone --depth 1 --branch core_v0.18.0 https://github.com/NVIDIA/Megatron-LM.git && \
    git clone --single-branch --branch core_r0.18.0 https://gitcode.com/Ascend/MindSpeed.git && \
    git -C MindSpeed checkout --detach bafa47afb8bdfa89bcdfb12b91461def43f6c391 && \
    git clone --single-branch --branch core_r0.18.0 https://gitcode.com/ascend/MegatronAdaptor.git && \
    git -C MegatronAdaptor checkout --detach 04951c8b8919efda9b9465017d2e0eaad6d344e0 && \
    git clone https://gitcode.com/ascend/TransformerEngineNPU.git && \
    git -C TransformerEngineNPU checkout --detach b2ada323e2e88b81e581fdf494bce53b78682935 && \
    git clone --depth 1 --branch v26.1.0 https://gitcode.com/ascend/MindSpeed-Ops.git && \
    git clone --depth 1 --branch v26.2.0_v0.5.0 https://gitcode.com/ascend/MindSpeed-Bridge.git && \
    git clone --depth 1 --branch v0.5.0 https://github.com/NVIDIA-NeMo/Megatron-Bridge.git

# Preserve Transformers' native Qwen3-ASR registration.
COPY patches/megatron_bridge_qwen3_asr.patch /tmp/megatron_bridge_qwen3_asr.patch
RUN git -C Megatron-Bridge apply --unidiff-zero /tmp/megatron_bridge_qwen3_asr.patch && \
    rm /tmp/megatron_bridge_qwen3_asr.patch

# Install vLLM + vLLM-Ascend from the official PyPI wheels (the wheels ship the
# prebuilt Ascend kernels), then resolve the runtime dependency graph without
# ever touching the CUDA-only packages.
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        pip install --no-cache-dir torch==2.10.0+cpu torchvision==0.25.0+cpu \
            --index-url https://download.pytorch.org/whl/cpu/; \
    fi && \
    pip install --no-cache-dir --no-deps vllm==0.30.0 vllm-ascend==0.30.0 torch-npu==2.10.0.post7 && \
    printf '%s\n' \
        'from importlib.metadata import requires' \
        'from pathlib import Path' \
        'from packaging.requirements import Requirement' \
        'from packaging.utils import canonicalize_name' \
        '' \
        'managed = {"torch", "torch-npu", "torchvision", "torchaudio", "triton", "triton-ascend", "vllm", "transformers"}' \
        'cuda_only = {"flashinfer-python", "flashinfer-cubin", "flash-attn", "humming-kernels", "quack-kernels", "tokenspeed-mla", "tilelang", "fastsafetensors", "helion", "pynvvideocodec", "torchcodec", "apache-tvm-ffi", "instanttensor", "zentorch", "deep-ep"}' \
        'selected = []' \
        'for package in ("vllm", "vllm-ascend"):' \
        '    for value in requires(package) or []:' \
        '        requirement = Requirement(value)' \
        '        if requirement.marker and not requirement.marker.evaluate({"extra": ""}):' \
        '            continue' \
        '        name = canonicalize_name(requirement.name)' \
        '        if name in managed or name in cuda_only or name.startswith("nvidia-"):' \
        '            continue' \
        '        if name == "mistral-common":' \
        '            requirement.extras.discard("image")' \
        '        selected.append(str(requirement))' \
        'selected += ["transformers==5.14.1"]' \
        'Path("/tmp/vllm-npu-deps.txt").write_text("\n".join(sorted(set(selected))) + "\n", encoding="utf-8")' \
        > /tmp/vllm-npu-filter.py && \
    python3 /tmp/vllm-npu-filter.py && \
    PIP_CONSTRAINT=/opt/verl-npu-constraints.txt pip install --no-cache-dir -r /tmp/vllm-npu-deps.txt && \
    python3 -m pip uninstall -y -q triton triton-ascend || true && \
    pip install --no-cache-dir --no-deps \
        --index-url https://triton-ascend.osinfra.cn/pypi/simple/ \
        --trusted-host triton-ascend.osinfra.cn \
        triton-ascend==3.6.0.post2 && \
    rm -rf /tmp/* /var/tmp/* && \
    pip cache purge

# Install the Megatron training stack from the pinned sources
RUN ARCH=$(uname -m) && \
    # Export and source env
    if [ "$ARCH" = "aarch64" ]; then \
        export LD_LIBRARY_PATH=/usr/local/Ascend/cann-9.1.0/aarch64-linux/devlib/linux/aarch64:$LD_LIBRARY_PATH; \
    elif [ "$ARCH" = "x86_64" ]; then \
        export LD_LIBRARY_PATH=/usr/local/Ascend/cann-9.1.0/x86_64-linux/devlib/linux/x86_64/:$LD_LIBRARY_PATH; \
    fi && \
    source /usr/local/Ascend/ascend-toolkit/set_env.sh && \
    source /usr/local/Ascend/nnal/atb/set_env.sh && \
    # Install Megatron & MindSpeed
    PIP_CONSTRAINT=/opt/verl-npu-constraints.txt pip install -e Megatron-LM && \
    # Install MegatronAdaptor
    PIP_CONSTRAINT=/opt/verl-npu-constraints.txt pip install -e MegatronAdaptor && \
    # Install TransformerEngineNPU
    PIP_CONSTRAINT=/opt/verl-npu-constraints.txt pip install -e TransformerEngineNPU --no-build-isolation && \
    # Install MindSpeed after MA and TENPU
    PIP_CONSTRAINT=/opt/verl-npu-constraints.txt pip install -e MindSpeed && \
    # Install MindSpeed-Ops
    PIP_CONSTRAINT=/opt/verl-npu-constraints.txt pip install -e MindSpeed-Ops --no-build-isolation --no-deps && \
    # Install MindSpeed-Bridge
    PIP_CONSTRAINT=/opt/verl-npu-constraints.txt pip install -r MindSpeed-Bridge/requirements.txt && \
    PIP_CONSTRAINT=/opt/verl-npu-constraints.txt pip install -e MindSpeed-Bridge --no-deps && \
    # Install Megatron-Bridge
    PIP_CONSTRAINT=/opt/verl-npu-constraints.txt pip install -e Megatron-Bridge --no-build-isolation --no-deps && \
    # Restore the vLLM 0.30.0 runtime versions after installing training dependencies
    pip install --no-cache-dir transformers==5.14.1 "xgrammar>=0.2.1,<1.0.0" && \
    # Clear extra files
    rm -rf /tmp/* /var/tmp/* && \
    pip cache purge

# Install verl at the pinned commit (recipe submodule included)
RUN git init verl && \
    git -C verl remote add origin https://github.com/verl-project/verl.git && \
    git -C verl fetch --depth 1 origin ${VERL_REF} && \
    git -C verl checkout FETCH_HEAD && \
    git -C verl submodule update --init --recursive --depth 1 && \
    pip install -r verl/requirements-npu.txt \
        --extra-index-url https://triton-ascend.osinfra.cn/pypi/simple/ \
        --trusted-host triton-ascend.osinfra.cn && \
    pip install -v --no-deps -e verl && \
    # Restore the vLLM Triton version after requirements-npu.txt installs its shared pin
    pip install --no-deps \
        --index-url https://triton-ascend.osinfra.cn/pypi/simple/ \
        --trusted-host triton-ascend.osinfra.cn \
        triton-ascend==3.6.0.post2 && \
    # Install the FLA NPU backend required during vLLM-Ascend worker initialization
    pip install --no-deps "flash-linear-attention-npu-a2==26.9.1" \
        --index-url https://mirrors.huaweicloud.com/ascend/repos/pypi && \
    # Clear extra files
    rm -rf /tmp/* /var/tmp/* && \
    pip cache purge

# Show install results
RUN pip list

# Setting Default Commands
CMD ["/bin/bash"]
