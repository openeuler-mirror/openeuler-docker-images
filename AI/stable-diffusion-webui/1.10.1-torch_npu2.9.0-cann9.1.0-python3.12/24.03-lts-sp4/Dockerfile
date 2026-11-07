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

ARG VERSION=1.10.1

LABEL author="openEuler CloudNative SIG" description="stable-diffusion-webui (AUTOMATIC1111) with Ascend NPU support (torch_npu + CANN)"


# rust/cargo build the tokenizers sdist pinned by upstream requirements.txt (transformers==4.30.2);
# PYO3_USE_ABI3_FORWARD_COMPATIBILITY lets its pyo3 0.18 backend target Python 3.12
ENV PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1

RUN dnf install -y rust cargo mesa-libGL glib2 openssl-devel && \
    dnf clean all

RUN git clone --branch v${VERSION} --depth 1 https://github.com/AUTOMATIC1111/stable-diffusion-webui.git /stable-diffusion-webui && \
    cd /stable-diffusion-webui && \
    python3 -m pip install --no-cache-dir torchvision==0.24.0 pytorch_lightning==1.9.4 && \
    python3 -m pip install --no-cache-dir -r requirements.txt && \
    python3 -m pip install --no-cache-dir -r requirements_npu.txt && \
    python3 -m pip install --no-cache-dir modelscope wheel && \
    python3 -m pip install --no-cache-dir --no-build-isolation "https://github.com/openai/CLIP/archive/d50d76daa670286dd6cacf3bcd80b5e4823fc8e1.zip" && \
    python3 -m pip cache purge

# launch.py re-checks requirements at startup; point it at the unpinned requirements.txt installed above
# so it does not try to reinstall requirements_versions.txt (whose 2023-era pins have no py3.12 wheels)
ENV REQS_FILE=requirements.txt \
    STABLE_DIFFUSION_REPO=https://github.com/w-e-w/stablediffusion.git

WORKDIR /stable-diffusion-webui
EXPOSE 7860

CMD ["python3", "launch.py", "--listen", "0.0.0.0", "--port", "7860", "--skip-torch-cuda-test", "--no-half"]
