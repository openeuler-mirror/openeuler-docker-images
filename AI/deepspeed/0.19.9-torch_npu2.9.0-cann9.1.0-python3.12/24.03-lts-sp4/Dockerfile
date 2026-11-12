FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

# Use PyPI directly; the base image pip.conf points at a mirror that is
# unreachable from the CI builders.
ENV PIP_INDEX_URL=https://pypi.org/simple

ARG VERSION=0.19.9

LABEL author="openEuler CloudNative SIG" description="DeepSpeed with Ascend NPU support (torch_npu + CANN)"


# Install DeepSpeed and the torchvision build matching the preinstalled torch,
# so pip does not replace the NPU torch stack
RUN python3 -m pip install --no-cache-dir deepspeed==${VERSION} "torchvision==0.24.*" && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
