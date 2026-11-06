FROM quay.io/ascend/cann:9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=0.9.0

LABEL author="openEuler CloudNative SIG" description="llama.cpp with Ascend NPU support (CANN backend)"

# Build llama.cpp with the GGML CANN backend (see docs/backend/CANN.md upstream).
# SOC_TYPE is pinned to ascend910b because no NPU is visible during the image build.
RUN source /usr/local/Ascend/ascend-toolkit/set_env.sh && \
    git clone --branch "v${VERSION}" --depth 1 https://github.com/ggml-org/llama.cpp.git /tmp/llama.cpp && \
    cmake -S /tmp/llama.cpp -B /tmp/llama.cpp/build \
        -DGGML_CANN=on \
        -DCMAKE_BUILD_TYPE=Release \
        -DSOC_TYPE=ascend910b \
        -DLLAMA_USE_PREBUILT_UI=OFF && \
    cmake --build /tmp/llama.cpp/build --config Release -j"$(nproc)" && \
    cmake --install /tmp/llama.cpp/build && \
    ldconfig && \
    rm -rf /tmp/llama.cpp

ENV LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}

CMD ["/bin/bash"]
