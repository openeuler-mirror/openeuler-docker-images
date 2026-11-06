FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=68fdc71
ARG PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

LABEL author="openEuler CloudNative SIG" description="InternLM model family with Ascend NPU inference stack (torch_npu + CANN)"

RUN pip config set global.index-url ${PIP_INDEX_URL}

RUN dnf -y install --nodocs --setopt=install_weak_deps=False git && dnf clean all

# Install the InternLM source tree (the main branch; existing releases predate the NPU guide)
RUN git clone https://github.com/InternLM/InternLM.git /opt/InternLM && \
    git -C /opt/InternLM checkout 68fdc71330059255fd647abf28219ad11e8e4865 && \
    rm -rf /opt/InternLM/.git

# Install the Transformers inference stack validated by the upstream NPU guide
RUN python3 -m pip install --no-cache-dir \
        'transformers==4.48.0' 'modelscope==1.37.0' sentencepiece safetensors && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
