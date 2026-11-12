FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

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

ARG VERSION=0.6.0

LABEL author="openEuler CloudNative SIG" description="LightX2V with Ascend NPU support (torch_npu + CANN)"

ENV PLATFORM=ascend_npu


# Install LightX2V from the release source (not published on PyPI), then the
# module-level dependency closure used by the Ascend quick start guard
RUN dnf install -y git && dnf clean all && \
    git clone --depth 1 --branch ${VERSION} https://github.com/ModelTC/LightX2V.git /opt/LightX2V && \
    python3 -m pip install --no-cache-dir --no-deps /opt/LightX2V && \
    python3 -m pip install --no-cache-dir numpy pillow einops loguru tqdm packaging safetensors regex ftfy gguf \
        imageio imageio-ffmpeg transformers prometheus-client pydantic pyzmq \
        modelscope==1.37.0 && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
