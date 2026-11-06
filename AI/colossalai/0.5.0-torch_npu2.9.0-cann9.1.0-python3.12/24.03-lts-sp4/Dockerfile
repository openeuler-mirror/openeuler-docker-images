FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.5.0
ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

LABEL author="openEuler CloudNative SIG" description="ColossalAI with Ascend NPU support (torch_npu + CANN)"

RUN pip config set global.index-url ${PIP_INDEX_URL}

# colossalai 0.5.0 pins torch<=2.5.1 in its upstream requirements, which would
# replace the preinstalled NPU torch stack; install it with --no-deps and add
# the dependencies Booster needs at import time (following the Ascend quick start)
RUN python3 -m pip install --no-cache-dir --no-deps colossalai==${VERSION} && \
    python3 -m pip install --no-cache-dir transformers peft galore_torch bitsandbytes einops modelscope && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
