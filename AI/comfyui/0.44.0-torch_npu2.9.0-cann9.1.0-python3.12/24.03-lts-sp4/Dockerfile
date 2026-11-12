FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

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

ARG VERSION=0.44.0

LABEL author="openEuler CloudNative SIG" description="ComfyUI with Ascend NPU support (torch_npu + CANN)"


# Install ComfyUI and its requirements; the torchvision/torchaudio pair is pinned to the versions matching torch 2.9.0 in the base image so pip never re-installs torch
RUN git clone --branch v${VERSION} --depth 1 https://github.com/comfyanonymous/ComfyUI.git /ComfyUI && \
    cd /ComfyUI && \
    python3 -m pip install --no-cache-dir torchvision==0.24.0 torchaudio==2.9.0 && \
    python3 -m pip install --no-cache-dir -r requirements.txt && \
    python3 -m pip install --no-cache-dir --upgrade torchsde einops transformers tokenizers safetensors aiohttp Pillow av && \
    python3 -m pip install --no-cache-dir modelscope && \
    python3 -m pip cache purge

WORKDIR /ComfyUI
EXPOSE 8188

CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188", "--disable-auto-launch"]
