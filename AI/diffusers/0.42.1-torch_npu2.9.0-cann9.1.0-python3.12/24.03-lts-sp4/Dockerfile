FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.42.1

LABEL author="openEuler CloudNative SIG" description="Diffusers (Hugging Face) with Ascend NPU support (torch_npu + CANN)"


# Install diffusers and the quick start companions
RUN python3 -m pip install --no-cache-dir diffusers==${VERSION} "transformers>=5.0,<6.0" "accelerate>=1.0,<2.0" "peft>=0.6" && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
