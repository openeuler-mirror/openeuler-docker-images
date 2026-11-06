FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=1.5.3

LABEL author="openEuler CloudNative SIG" description="Cache-DiT with Ascend NPU support (torch_npu + CANN)"


# Install cache-dit with the NPU dependencies used by the Ascend quick start guard
RUN python3 -m pip install --no-cache-dir cache-dit==${VERSION} \
        einops sentencepiece accelerate diffusers \
        modelscope==1.37.0 && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
