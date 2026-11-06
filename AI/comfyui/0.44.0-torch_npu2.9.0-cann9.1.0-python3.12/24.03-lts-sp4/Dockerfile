FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

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
