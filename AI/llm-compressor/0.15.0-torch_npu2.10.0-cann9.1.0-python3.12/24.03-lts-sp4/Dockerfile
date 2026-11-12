FROM quay.io/ascend/torch-npu:2.10.0.post6-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.15.0

LABEL author="openEuler CloudNative SIG" description="LLM Compressor (vLLM project) with Ascend NPU support (torch_npu + CANN)"


# Install llmcompressor (the PyPI package name of llm-compressor)
RUN python3 -m pip install --no-cache-dir llmcompressor==${VERSION} && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
