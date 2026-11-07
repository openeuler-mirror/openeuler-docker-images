FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

# Use PyPI directly; the base image pip.conf points at a mirror that is
# unreachable from the CI builders.
ENV PIP_INDEX_URL=https://pypi.org/simple

ARG VERSION=0.5.5

LABEL author="openEuler CloudNative SIG" description="OpenCompass (LLM evaluation framework) with Ascend NPU support (torch_npu + CANN)"


# Install OpenCompass and ModelScope model hub support.
# torch/torch_npu from the base image satisfy the declared torch requirement
# (>=1.13.1) and are not reinstalled; transformers resolves to the 4.x line.
RUN python3 -m pip install --no-cache-dir opencompass==${VERSION} modelscope && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
