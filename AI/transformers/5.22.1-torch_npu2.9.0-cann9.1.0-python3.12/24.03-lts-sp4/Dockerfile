FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=5.22.1
ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

LABEL author="openEuler CloudNative SIG" description="Transformers (Hugging Face) with Ascend NPU support (torch_npu + CANN)"

RUN pip config set global.index-url ${PIP_INDEX_URL}

# Install transformers and accelerate
RUN python3 -m pip install --no-cache-dir transformers==${VERSION} accelerate && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
