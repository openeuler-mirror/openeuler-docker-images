FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.7.0

LABEL author="openEuler CloudNative SIG" description="xDiT (xfuser) with Ascend NPU support (torch_npu + CANN)"


# Install xDiT (PyPI package xfuser) with the Triton and ModelScope versions pinned by the Ascend quick start guard
RUN python3 -m pip install --no-cache-dir xfuser==${VERSION} \
        triton==3.5.0 \
        modelscope==1.37.0 && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
