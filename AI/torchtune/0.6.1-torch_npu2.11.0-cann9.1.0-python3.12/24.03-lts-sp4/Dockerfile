FROM quay.io/ascend/torch-npu:2.11.0.post2-cann9.1.0-910b-openeuler24.03-py3.12

# Use PyPI directly; the base image pip.conf points at a mirror that is
# unreachable from the CI builders.
ENV PIP_INDEX_URL=https://pypi.org/simple

ARG VERSION=0.6.1

LABEL author="openEuler CloudNative SIG" description="Torchtune with Ascend NPU support (torch_npu + CANN)"


# torchao is pinned below 0.16 because torchtune 0.6.x still uses the pre-0.16
# torchao APIs; modelscope pulls base models from the ModelScope mirror
RUN python3 -m pip install --no-cache-dir torchtune==${VERSION} "modelscope==1.37.0" "torchao<0.16" && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
