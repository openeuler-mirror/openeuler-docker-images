FROM quay.io/ascend/torch-npu:2.11.0.post2-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.15.5

LABEL author="openEuler CloudNative SIG" description="TensorDict (PyTorch) with Ascend NPU support (torch_npu + CANN)"


# Install tensordict on top of the preinstalled torch/torch_npu stack
RUN python3 -m pip install --no-cache-dir tensordict==${VERSION} && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
