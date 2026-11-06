FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=4.2.1

LABEL author="openEuler CloudNative SIG" description="open_clip (mlfoundations) with Ascend NPU support (torch_npu + CANN)"


# Install open_clip_torch; torchvision is pinned to the release matching the torch 2.9.0 stack
RUN python3 -m pip install --no-cache-dir "open_clip_torch[training]==${VERSION}" torchvision==0.24.0 && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
