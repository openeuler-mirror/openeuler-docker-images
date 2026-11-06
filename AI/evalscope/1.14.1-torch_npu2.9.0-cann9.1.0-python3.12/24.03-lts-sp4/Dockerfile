FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=1.14.1
ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

LABEL author="openEuler CloudNative SIG" description="EvalScope (ModelScope LLM evaluation framework) with Ascend NPU support (torch_npu + CANN)"

RUN pip config set global.index-url ${PIP_INDEX_URL}

# Install EvalScope with the Native (transformers + accelerate) backend deps:
# - numpy stays >=2: the datasets/pyarrow pulled in by modelscope require it;
# - accelerate is not declared by evalscope but is required when the local
#   model wrapper passes device_map (on NPU it resolves to "npu").
RUN python3 -m pip install --no-cache-dir evalscope==${VERSION} "numpy>=2,<3" accelerate && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
