FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.50.2

LABEL author="openEuler CloudNative SIG" description="bitsandbytes with Ascend NPU support (torch_npu + CANN)"


# Install bitsandbytes (PyPI release; 4-bit quantized weights run on the Ascend NPU)
RUN python3 -m pip install --no-cache-dir bitsandbytes==${VERSION} && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
