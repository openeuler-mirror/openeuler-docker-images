FROM quay.io/ascend/torch-npu:2.10.0.post6-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=2.1.1

LABEL author="openEuler CloudNative SIG" description="AReaL large-scale asynchronous RL system with Ascend NPU support (torch_npu + CANN)"


RUN dnf -y install --nodocs --setopt=install_weak_deps=False git && dnf clean all

RUN git clone --depth 1 --branch v${VERSION} https://github.com/areal-project/AReaL.git /opt/AReaL

# NPU constraints that keep the preinstalled torch/torch_npu stack untouched
RUN printf 'torch==2.10.0\ntorchvision==0.25.0\ntorchaudio==2.10.0\n' > /opt/areal-npu-constraints.txt

# Install AReaL from source the same way the Ascend CI does, then add its core runtime dependencies
RUN python3 -m pip install --no-cache-dir uv && \
    PIP_CONSTRAINT=/opt/areal-npu-constraints.txt uv pip install --system --no-deps -e /opt/AReaL && \
    PIP_CONSTRAINT=/opt/areal-npu-constraints.txt python3 -m pip install --no-cache-dir \
        'ray[default]' 'omegaconf==2.4.0.dev2' 'hydra-core==1.4.0.dev1' \
        'datasets' 'transformers>=5.0.0,<=5.3.0' 'huggingface_hub' accelerate 'peft<=0.18.1' \
        pandas matplotlib seaborn pillow pylatexenc zstandard setproctitle nltk sentencepiece \
        einops orjson tqdm rich pydantic pyyaml packaging lark tabulate pybase64 msgspec \
        'math-verify==0.8.0' python-dotenv json5 psutil 'aiohttp>=3.13.3,<4' 'httpx>=0.28.1' \
        pyzmq regex python_dateutil word2number pebble timeout-decorator prettytable h5py \
        'mathruler==0.1.0' wandb tensorboardx colorama colorlog redis 'fastapi>=0.115.12' \
        uvicorn 'uvloop>=0.21.0' flask 'tenacity>=8.2.0' click 'networkx==3.3' \
        mistral-common openai cookiecutter torchdata && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
