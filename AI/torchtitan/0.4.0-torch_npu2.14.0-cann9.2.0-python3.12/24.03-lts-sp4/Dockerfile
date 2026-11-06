FROM quay.io/ascend/torch-npu:2.14.0-cann9.2.0-910b-openeuler24.03-py3.12

ARG VERSION=0.4.0
ARG TRITON_ASCEND_INDEX_URL="https://repo.huaweicloud.com/ascend/repos/pypi/test"

LABEL author="openEuler CloudNative SIG" description="Torchtitan with Ascend NPU support (torch_npu + CANN)"


# Install the Ascend Triton backend matching torch 2.14 / CANN 9.2.0 (with
# --no-deps so the community CUDA triton does not shadow it), then torchtitan
# and the ModelScope client used to pull tokenizers/models
RUN python3 -m pip install --no-cache-dir --no-deps --index-url ${TRITON_ASCEND_INDEX_URL} triton-ascend==3.6.0 && \
    python3 -m pip install --no-cache-dir pybind11 modelscope==1.40.2 torchtitan==${VERSION} && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
