FROM quay.io/ascend/torch-npu:2.11.0.post2-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.2.0

LABEL author="openEuler CloudNative SIG" description="XTuner with Ascend NPU support (torch_npu + CANN)"


# xtuner 0.2.0 pins a torchvision/transformers combination that would replace
# the preinstalled NPU torch stack, so install it with --no-deps and add the
# runtime dependencies used by the train/chat tools (following the Ascend
# quick start; bitsandbytes has no usable aarch64 NPU build and is not needed
# for plain LoRA fine-tuning)
RUN python3 -m pip install --no-cache-dir --no-deps xtuner==${VERSION} && \
    python3 -m pip install --no-cache-dir \
        "mmengine==0.10.6" \
        "transformers==4.48.0" \
        "peft>=0.14.0" \
        "datasets>=3.2.0,<4.0.0" \
        einops loguru openpyxl scikit-image scipy \
        SentencePiece tiktoken transformers_stream_generator cyclopts \
        "opencv-python-headless<=4.12.0.88" \
        "torchvision==0.26.0" \
        timm pyarrow pydantic tensorboard \
        xxhash imageio py-libnuma GitPython && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
