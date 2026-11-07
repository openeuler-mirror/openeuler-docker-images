FROM quay.io/ascend/cann:9.1.0-910b-openeuler24.03-py3.12

# Use PyPI directly; the base image pip.conf points at a mirror that is
# unreachable from the CI builders.
ENV PIP_INDEX_URL=https://pypi.org/simple

ARG VERSION=0.40.15
ARG GO_VERSION=1.26.10
ARG CANN_PATCH_URL="https://api.github.com/repos/cosdt-ci-test/workflows/contents/projects/ollama/patches/ollama-cann.patch"

LABEL author="openEuler CloudNative SIG" description="Ollama with Ascend NPU support (experimental CANN backend)"

# Go toolchain required to build the Ollama server
RUN arch="$(uname -m)" && \
    case "$arch" in aarch64) goarch=arm64 ;; x86_64) goarch=amd64 ;; *) echo "unsupported arch: $arch"; exit 1 ;; esac && \
    curl -fL --retry 3 -o /tmp/go.tgz "https://go.dev/dl/go${GO_VERSION}.linux-${goarch}.tar.gz" && \
    tar -C /usr/local -xzf /tmp/go.tgz && \
    rm -f /tmp/go.tgz

# Build Ollama from source with the experimental CANN backend patch
# (upstream does not ship Ascend support yet, see the quick start guide)
RUN export PATH=/usr/local/go/bin:$PATH && \
    pip3 install --no-cache-dir cmake==3.31.10 && \
    source /usr/local/Ascend/ascend-toolkit/set_env.sh && \
    curl -fsSL -H "Accept: application/vnd.github.raw" -o /tmp/ollama-cann.patch "${CANN_PATCH_URL}" && \
    git clone --depth 1 --branch "v${VERSION}" https://github.com/ollama/ollama.git /tmp/ollama && \
    git -C /tmp/ollama apply --check /tmp/ollama-cann.patch && \
    git -C /tmp/ollama apply /tmp/ollama-cann.patch && \
    cmake -S /tmp/ollama -B /tmp/ollama/build \
        -DCMAKE_BUILD_TYPE=Release \
        -DOLLAMA_LLAMA_BACKENDS=cann \
        -DOLLAMA_BUILD_PARALLEL=8 \
        -DGGML_CPU_ALL_VARIANTS=OFF \
        -DCANN_INSTALL_DIR="${ASCEND_HOME_PATH}" \
        -DSOC_TYPE=Ascend910B4 \
        -DOLLAMA_VERSION="v${VERSION}" && \
    cmake --build /tmp/ollama/build --parallel 8 && \
    install -m 755 /tmp/ollama/ollama /usr/local/bin/ollama && \
    mkdir -p /usr/local/lib/ollama && \
    cp -a /tmp/ollama/build/lib/ollama/. /usr/local/lib/ollama/ && \
    rm -rf /tmp/ollama /tmp/ollama-cann.patch /usr/local/go /root/.cache/go-build /root/go

# Force the CANN runner library built above
ENV OLLAMA_LLM_LIBRARY=cann

CMD ["ollama", "serve"]
