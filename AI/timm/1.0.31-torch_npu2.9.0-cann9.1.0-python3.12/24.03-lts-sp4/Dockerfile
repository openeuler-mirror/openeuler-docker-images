FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=1.0.31

LABEL author="openEuler CloudNative SIG" description="timm (pytorch-image-models, Hugging Face) with Ascend NPU support (torch_npu + CANN)"


# Install timm; torchvision is pinned to the release matching the torch 2.9.0 stack
RUN python3 -m pip install --no-cache-dir timm==${VERSION} torchvision==0.24.0 && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
