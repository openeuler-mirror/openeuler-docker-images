FROM quay.io/ascend/cann:8.1.rc1-910b-openeuler22.03-py3.10

ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

RUN yum update -y && \
    yum install -y python3-pip git vim wget net-tools && \
    rm -rf /var/cache/yum

WORKDIR /workspace

RUN pip config set global.index-url ${PIP_INDEX_URL}

# Install vLLM
ARG VLLM_REPO=https://github.com/vllm-project/vllm.git
ARG VLLM_TAG=v0.7.3
RUN git clone --depth 1 $VLLM_REPO --branch $VLLM_TAG /vllm-workspace/vllm
RUN VLLM_TARGET_DEVICE="empty" python3 -m pip install -e /vllm-workspace/vllm/ --extra-index https://download.pytorch.org/whl/cpu/ && \
    python3 -m pip cache purge

# Install vllm-ascend
ARG VLLM_ASCEND_REPO=https://github.com/vllm-project/vllm-ascend.git
ARG VLLM_ASCEND_TAG=v0.7.3
RUN git clone $VLLM_ASCEND_REPO --branch $VLLM_ASCEND_TAG /vllm-workspace/vllm-ascend
RUN python3 -m pip install -e /vllm-workspace/vllm-ascend/ --extra-index https://download.pytorch.org/whl/cpu/ && \
    python3 -m pip cache purge

# Install modelscope (for fast download) and ray (for multinode)
# TODO(yikun): Remove "<1.23.0" after v0.7.4 which resloved by https://github.com/vllm-project/vllm/pull/13807
RUN python3 -m pip install "modelscope<1.23.0" ray && \
    python3 -m pip cache purge

CMD ["/bin/bash"]