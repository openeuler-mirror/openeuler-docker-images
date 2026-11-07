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

ARG VERSION=0cbd94d

LABEL author="openEuler CloudNative SIG" description="MiniOneRec (generative recommendation framework) with Ascend NPU support (torch_npu + CANN)"


# Clone MiniOneRec and install its NPU dependencies (torch/torch_npu already
# come from the base image and are not reinstalled). The pinned versions follow
# the Ascend quick start guard; bitsandbytes 0.48.1 is pinned to the release
# that ships aarch64 wheels (sft.py/evaluate.py import it unconditionally).
RUN dnf install -y git && dnf clean all && \
    git clone https://github.com/AkaliKong/MiniOneRec.git /opt/MiniOneRec && \
    git -C /opt/MiniOneRec checkout ${VERSION} && \
    python3 -m pip install --no-cache-dir \
        modelscope transformers==4.57.1 accelerate==1.10.1 datasets==4.2.0 \
        tokenizers==0.22.1 fire==0.7.1 pandas==2.2.2 tqdm bitsandbytes==0.48.1 \
        trl==0.24.0 scikit-learn==1.5.2 wandb==0.22.2 && \
    python3 -m pip cache purge

WORKDIR /opt/MiniOneRec

CMD ["/bin/bash"]
