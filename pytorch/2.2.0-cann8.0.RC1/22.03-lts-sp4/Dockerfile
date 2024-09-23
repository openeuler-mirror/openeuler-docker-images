ARG BASE=openeuler/cann:8.0.RC1-oe2203sp4
FROM ${BASE}

# Arguments
ARG VERSION=2.2.0
ARG AUDIO_VERSION=2.2.0
ARG NPU_VERSION=2.2.0
ARG TORCH_VERSION=0.17.0

# Change the default shell
SHELL [ "/bin/bash", "-c" ]

# Install pytorch, torch-npu and related packages
RUN if [ "${VERSION}" == "2.1.0" ]; then \
        TORCH_VERSION=0.16.0; \
        AUDIO_VERSION=2.1.0; \
        NPU_VERSION=2.1.0; \
    elif [ "${VERSION}" == "2.2.0" ]; then \
        TORCH_VERSION=0.17.0; \
        AUDIO_VERSION=2.2.0; \
        NPU_VERSION=2.2.0; \
    else \
        echo "Not supported version: ${VERSION}. Feel free to submit an issue to us: https://github.com/cosdt/dockerfiles/issues"; \
        exit 1; \
    fi && \
    # Uninstall the latest numpy and sympy first, as the right versions will be installed again \
    # after installing following packages \
    pip uninstall -y numpy sympy && \
    pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cpu \
        torch==${VERSION} \
        torchvision==${TORCH_VERSION} \
        torchaudio==${AUDIO_VERSION} && \
    pip install --no-cache-dir \
        torch-npu==${NPU_VERSION}