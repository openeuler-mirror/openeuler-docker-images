FROM quay.io/ascend/torch-npu:2.11.0.post2-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.21.1
ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

LABEL author="openEuler CloudNative SIG" description="Axolotl LLM fine-tuning framework with Ascend NPU support (torch_npu + CANN)"

RUN pip config set global.index-url ${PIP_INDEX_URL}

# Install axolotl and the LoRA training dependencies validated on Ascend
RUN python3 -m pip install --no-cache-dir --no-build-isolation --no-deps axolotl==${VERSION} && \
    python3 -m pip install --no-cache-dir \
        'packaging==26.0' 'huggingface_hub==1.17.0' 'peft==0.19.1' \
        'tokenizers==0.22.2' 'transformers==5.14.1' 'accelerate==1.13.0' \
        'datasets==4.8.4' 'trl==1.8.0' \
        sentencepiece einops colorama fire addict \
        'typer==0.25.1' 'pydantic==2.12.5' 'python-dotenv==1.0.1' \
        requests art 'hf_xet==1.4.3' hf_transfer \
        'axolotl-contribs-lgpl==0.0.7' 'axolotl-contribs-mit==0.0.6' \
        'bitsandbytes==0.49.1' modelscope scipy evaluate tensorboard \
        'schedulefree==1.4.1' numba posthog fastcore wandb torchao && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
