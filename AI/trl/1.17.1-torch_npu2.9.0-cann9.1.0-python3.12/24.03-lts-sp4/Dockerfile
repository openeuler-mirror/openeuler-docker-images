FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=1.17.1

LABEL author="openEuler CloudNative SIG" description="TRL (Hugging Face) with Ascend NPU support (torch_npu + CANN)"


# Install trl and peft (LoRA support for the trainers)
RUN python3 -m pip install --no-cache-dir trl==${VERSION} peft && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
