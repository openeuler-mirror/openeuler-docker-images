FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=4.6.0
ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

LABEL author="openEuler CloudNative SIG" description="ms-swift with Ascend NPU support (torch_npu + CANN)"

RUN pip config set global.index-url ${PIP_INDEX_URL}

# Install the companion stack pinned by the Ascend quick start, then ms-swift
# itself; nothing in the dependency tree is allowed to replace the NPU torch
RUN python3 -m pip install --no-cache-dir "transformers<5.0" "peft<0.19" "modelscope==1.37.0" && \
    python3 -m pip install --no-cache-dir ms-swift==${VERSION} && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
