FROM quay.io/ascend/torch-npu:2.11.0.post2-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.11.2

LABEL author="openEuler CloudNative SIG" description="OpenRLHF RLHF framework with Ascend NPU support (torch_npu + CANN)"


RUN dnf -y install --nodocs --setopt=install_weak_deps=False git && dnf clean all

# Install the OpenRLHF release source tree (the aarch64 PyPI wheel is not installable)
RUN git clone --depth 1 --branch v${VERSION} https://github.com/OpenRLHF/OpenRLHF.git /opt/OpenRLHF

ENV PYTHONPATH=/opt/OpenRLHF:/opt/openrlhf-qs

# Map torch.cuda to the NPU and provide the flash_attn import stub required by OpenRLHF
RUN SP_DIR=$(python3 -c 'import site; print(site.getsitepackages()[0])') && \
    echo 'from torch_npu.contrib import transfer_to_npu' > ${SP_DIR}/sitecustomize.py && \
    mkdir -p /opt/openrlhf-qs/flash_attn/utils && \
    : > /opt/openrlhf-qs/flash_attn/__init__.py && \
    : > /opt/openrlhf-qs/flash_attn/utils/__init__.py && \
    printf "from einops import rearrange\n\ndef index_first_axis(*args, **kwargs):\n    raise RuntimeError('packing needs CUDA flash_attn')\n\ndef unpad_input(*args, **kwargs):\n    raise RuntimeError('packing needs CUDA flash_attn')\n\ndef pad_input(*args, **kwargs):\n    raise RuntimeError('packing needs CUDA flash_attn')\n" > /opt/openrlhf-qs/flash_attn/bert_padding.py && \
    printf "def all_gather(*args, **kwargs):\n    raise RuntimeError('ring attention needs CUDA flash_attn')\n" > /opt/openrlhf-qs/flash_attn/utils/distributed.py

# Install the SFT-path dependencies validated on Ascend
RUN python3 -m pip install --no-cache-dir \
        accelerate aiohttp datasets 'deepspeed==0.19.5' einops 'grpcio>=1.74.0' \
        'huggingface_hub>=1.0.0' jsonlines loralib optimum 'optree>=0.15.0' \
        packaging peft pylatexenc tensorboard torchdata torchmetrics tqdm \
        'transformers==5.15.0' transformers_stream_generator modelscope && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
