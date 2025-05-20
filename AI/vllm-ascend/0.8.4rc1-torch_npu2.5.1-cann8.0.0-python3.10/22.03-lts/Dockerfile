FROM quay.io/ascend/cann:8.0.0-910b-openeuler22.03-py3.10

ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
ARG COMPILE_CUSTOM_KERNELS=0

ENV COMPILE_CUSTOM_KERNELS=${COMPILE_CUSTOM_KERNELS}

RUN yum update -y && \
    yum install -y python3-pip git vim wget net-tools make gcc gcc-c++ && \
    rm -rf /var/cache/yum &&\
    rm -rf /tmp/*

RUN pip config set global.index-url ${PIP_INDEX_URL}

WORKDIR /workspace

# Install vLLM
ARG VLLM_REPO=https://github.com/vllm-project/vllm.git
ARG VLLM_TAG=v0.8.4

RUN git clone --depth 1 $VLLM_REPO --branch $VLLM_TAG /workspace/vllm
RUN VLLM_TARGET_DEVICE="empty" python3 -m pip install /workspace/vllm/ --extra-index https://download.pytorch.org/whl/cpu/
# In x86, triton will be installed by vllm. But in Ascend, triton doesn't work correctly. we need to uninstall it.
RUN python3 -m pip uninstall -y triton

# Install torch-npu
ARG VLLM_ASCEND_REPO=https://github.com/vllm-project/vllm-ascend.git
ARG VLLM_ASCEND_TAG=v0.8.4rc1
RUN git clone $VLLM_ASCEND_REPO --branch $VLLM_ASCEND_TAG /workspace/vllm-ascend
RUN bash /workspace/vllm-ascend/pta_install.sh

# Install vllm-ascend
RUN source /usr/local/Ascend/ascend-toolkit/set_env.sh && \
    source /usr/local/Ascend/nnal/atb/set_env.sh && \
    export LD_LIBRARY_PATH=/usr/local/Ascend/ascend-toolkit/latest/`uname -i`-linux/devlib:$LD_LIBRARY_PATH && \
    export LIBRARY_PATH=/usr/local/Ascend/ascend-toolkit/latest/lib64:$LIBRARY_PATH && \
    python3 -m pip install -v /workspace/vllm-ascend/ --extra-index https://download.pytorch.org/whl/cpu/

# Install modelscope (for fast download) and ray (for multinode)
RUN python3 -m pip install modelscope ray

CMD ["/bin/bash"]
