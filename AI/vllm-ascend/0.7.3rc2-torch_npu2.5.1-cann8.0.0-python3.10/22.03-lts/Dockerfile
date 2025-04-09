FROM quay.io/ascend/cann:8.0.0-910b-openeuler22.03-py3.10

RUN yum update -y && \
    yum install -y python3-pip git vim wget net-tools && \
    rm -rf /var/cache/yum &&\
    rm -rf /tmp/*

# Install vLLM
ARG VLLM_REPO=https://github.com/vllm-project/vllm.git
ARG VLLM_TAG=v0.7.3
ARG VLLM_ASCEND_REPO=https://github.com/vllm-project/vllm-ascend.git
ARG VLLM_ASCEND_TAG=v0.7.3rc2

RUN git clone $VLLM_REPO --branch $VLLM_TAG /workspace/vllm
RUN VLLM_TARGET_DEVICE="empty" python3 -m pip install /workspace/vllm/ --extra-index https://download.pytorch.org/whl/cpu/
# In x86, triton will be installed by vllm. But in Ascend, triton doesn't work correctly. we need to uninstall it.
RUN python3 -m pip uninstall -y triton

RUN git clone $VLLM_ASCEND_REPO --branch $VLLM_ASCEND_TAG /workspace/vllm-ascend


# Install vllm-ascend
RUN python3 -m pip install /workspace/vllm-ascend/ --extra-index https://download.pytorch.org/whl/cpu/

# Install torch-npu
RUN bash /workspace/vllm-ascend/pta_install.sh

# Install modelscope (for fast download) and ray (for multinode)
RUN python3 -m pip install modelscope ray

CMD ["/bin/bash"]