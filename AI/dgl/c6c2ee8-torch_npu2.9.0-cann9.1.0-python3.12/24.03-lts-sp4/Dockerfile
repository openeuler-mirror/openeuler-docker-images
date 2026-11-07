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

ARG VERSION=c6c2ee8

LABEL author="openEuler CloudNative SIG" description="DGL-Ascend (DGL with Ascend NPU support) with torch_npu + CANN"


# Build and install DGL-Ascend (BUPT-GAMMA Ascend adaptation of DGL) from source.
# The build script auto-detects the Ascend SoC and falls back to ascend910b4
# when no NPU is visible during the docker build.
RUN dnf install -y git gcc gcc-c++ make cmake && dnf clean all && \
    source /usr/local/Ascend/ascend-toolkit/set_env.sh && \
    git clone https://github.com/BUPT-GAMMA/dgl-ascend.git /tmp/dgl-ascend && \
    git -C /tmp/dgl-ascend checkout ${VERSION} && \
    git -C /tmp/dgl-ascend submodule update --init --recursive && \
    bash /tmp/dgl-ascend/script/build_dgl_ascend.sh -t release && \
    python3 -m pip install --no-cache-dir "Cython==3.0.12" packaging pandas "pydantic>=2.0" tqdm && \
    cd /tmp/dgl-ascend/python && \
    python3 setup.py install && \
    python3 setup.py build_ext --inplace && \
    cd / && rm -rf /tmp/dgl-ascend && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
