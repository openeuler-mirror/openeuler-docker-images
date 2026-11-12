FROM quay.io/ascend/torch-npu:2.10.0.post6-cann9.1.0-910b-openeuler24.03-py3.12

# Use PyPI directly; the base image pip.conf points at a mirror that is
# unreachable from the CI builders.
ENV PIP_INDEX_URL=https://pypi.org/simple

# Harden git against the flaky CI network (HTTP/2 resets, stalled transfers).
ENV GIT_CONFIG_COUNT=4 \
    GIT_CONFIG_KEY_0=http.version \
    GIT_CONFIG_VALUE_0=HTTP/1.1 \
    GIT_CONFIG_KEY_1=http.postBuffer \
    GIT_CONFIG_VALUE_1=524288000 \
    GIT_CONFIG_KEY_2=http.lowSpeedLimit \
    GIT_CONFIG_VALUE_2=1000 \
    GIT_CONFIG_KEY_3=http.lowSpeedTime \
    GIT_CONFIG_VALUE_3=60

ARG VERSION=b520d2b

LABEL author="openEuler CloudNative SIG" description="SpecForge (speculative decoding training framework) with Ascend NPU support (torch_npu + CANN)"


# Install SpecForge from source (the PyPI wheel does not ship the example
# configs and the sglang patch set under examples/ and patches/) plus the
# runtime dependencies of the typed CLI. specforge is installed with --no-deps
# so its pyproject pins (torch==2.13.0, transformers==5.x) cannot clobber the
# image's torch_npu stack. An SGLang server with the spec-capture patches is
# required for online training and is provisioned separately (see the README).
RUN dnf install -y git libibverbs libcurl numactl-libs && dnf clean all && \
    git clone https://github.com/sgl-project/SpecForge.git /opt/SpecForge && \
    git -C /opt/SpecForge checkout ${VERSION} && \
    python3 -m pip install --no-cache-dir --no-deps /opt/SpecForge && \
    python3 -m pip install --no-cache-dir \
        "click>=8.0" accelerate pyyaml tqdm pydantic psutil safetensors requests typing-extensions \
        modelscope "mooncake-transfer-engine-npu==0.3.13.post1" && \
    python3 -m pip cache purge

WORKDIR /opt/SpecForge

CMD ["/bin/bash"]
