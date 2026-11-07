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

ARG VERSION=0.10.0

LABEL author="openEuler CloudNative SIG" description="AReno RL post-training toolkit with Ascend NPU support (torch_npu + CANN)"


RUN dnf -y install --nodocs --setopt=install_weak_deps=False git cmake binutils gcc gcc-c++ && dnf clean all

# Install AReno from source; the build compiles the areno.accel._areno_accel_npu Ascend C extension
RUN git clone --depth 1 --branch v${VERSION} https://github.com/inclusionAI/AReno.git /opt/AReno && \
    cd /opt/AReno && \
    python3 -m pip install --no-cache-dir -U 'setuptools>=69' wheel && \
    . /usr/local/Ascend/ascend-toolkit/set_env.sh && \
    MAX_JOBS=$(nproc) python3 -m pip install --no-cache-dir --no-build-isolation --no-deps -e . && \
    python3 -m pip install --no-cache-dir $(grep -vE '^[[:space:]]*(#|flash-attn-npu|flash-linear-attention)' requirements/npu.txt) && \
    python3 -m pip install --no-cache-dir 'transformers==5.15.*' openai httpx && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
