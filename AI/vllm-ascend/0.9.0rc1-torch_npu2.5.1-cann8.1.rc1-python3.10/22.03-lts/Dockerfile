FROM quay.io/ascend/cann:8.1.rc1-910b-openeuler22.03-py3.10

ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"
ARG COMPILE_CUSTOM_KERNELS=1

ENV COMPILE_CUSTOM_KERNELS=${COMPILE_CUSTOM_KERNELS}

RUN yum update -y && \
    yum install -y python3-pip git vim wget net-tools make gcc gcc-c++ && \
    rm -rf /var/cache/yum &&\
    rm -rf /tmp/*

RUN pip config set global.index-url ${PIP_INDEX_URL}

WORKDIR /vllm-workspace

# Install vLLM
ARG VLLM_REPO=https://github.com/vllm-project/vllm.git
ARG VLLM_ASCEND_REPO=https://github.com/vllm-project/vllm-ascend.git
ARG VLLM_TAG=v0.9.0
ARG VLLM_ASCEND_TAG=v0.9.0rc1

RUN git clone $VLLM_REPO --branch $VLLM_TAG /vllm-workspace/vllm
# In x86, triton will be installed by vllm. But in Ascend, triton doesn't work correctly. we need to uninstall it.
RUN VLLM_TARGET_DEVICE="empty" python3 -m pip install -e /vllm-workspace/vllm/ --extra-index https://download.pytorch.org/whl/cpu/ && \
    python3 -m pip uninstall -y triton && \
    python3 -m pip cache purge


RUN git clone $VLLM_ASCEND_REPO --branch $VLLM_ASCEND_TAG /vllm-workspace/vllm-ascend
# Install vllm-ascend
RUN source /usr/local/Ascend/ascend-toolkit/set_env.sh && \
    source /usr/local/Ascend/nnal/atb/set_env.sh && \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/Ascend/ascend-toolkit/latest/`uname -i`-linux/devlib && \
    python3 -m pip install -e /vllm-workspace/vllm-ascend/ --extra-index https://download.pytorch.org/whl/cpu/ && \
    python3 -m pip cache purge

# Install modelscope (for fast download) and ray (for multinode)
RUN python3 -m pip install modelscope ray

CMD ["/bin/bash"]