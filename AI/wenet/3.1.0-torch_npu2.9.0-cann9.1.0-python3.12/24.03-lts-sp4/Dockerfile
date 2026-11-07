FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

# Use PyPI directly; the base image pip.conf points at a mirror that is
# unreachable from the CI builders.
ENV PIP_INDEX_URL=https://pypi.org/simple

ARG VERSION=3.1.0

LABEL author="openEuler CloudNative SIG" description="WeNet with Ascend NPU support (torch_npu + CANN)"


# sox/libgomp provide the audio tooling and OpenMP runtime required by torchaudio
RUN dnf install -y sox libgomp && \
    dnf clean all

# Install WeNet from the upstream release tag; the [torch-npu] extra is not used because it pins torch==2.2.0,
# while this image keeps the torch 2.9.0 + torch_npu 2.9.0.post8 stack of the base image
RUN git clone --branch v${VERSION} --depth 1 https://github.com/wenet-e2e/wenet.git /wenet && \
    cd /wenet && \
    python3 -m pip install --no-cache-dir "setuptools<82" wheel && \
    python3 -m pip install --no-cache-dir --no-build-isolation "openai-whisper==20231117" && \
    python3 -m pip install --no-cache-dir --no-build-isolation torchaudio==2.9.0 . && \
    python3 -m pip install --no-cache-dir deepspeed tensorboardX sox && \
    python3 -m pip cache purge

WORKDIR /wenet

CMD ["/bin/bash"]
