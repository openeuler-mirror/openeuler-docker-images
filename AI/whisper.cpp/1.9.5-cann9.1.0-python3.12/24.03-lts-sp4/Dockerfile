FROM quay.io/ascend/cann:9.1.0-910b-openeuler24.03-py3.12

ARG VERSION=1.9.5

LABEL author="openEuler CloudNative SIG" description="whisper.cpp with Ascend NPU support (CANN backend)"

# Build whisper.cpp with the GGML CANN backend.
# SOC_TYPE is pinned to ascend910b because no NPU is visible during the image build.
RUN source /usr/local/Ascend/ascend-toolkit/set_env.sh && \
    git clone --branch "v${VERSION}" --depth 1 https://github.com/ggml-org/whisper.cpp.git /tmp/whisper.cpp && \
    cmake -S /tmp/whisper.cpp -B /tmp/whisper.cpp/build \
        -DGGML_CANN=on \
        -DCMAKE_BUILD_TYPE=Release \
        -DSOC_TYPE=ascend910b && \
    cmake --build /tmp/whisper.cpp/build --config Release -j"$(nproc)" && \
    cmake --install /tmp/whisper.cpp/build && \
    mkdir -p /usr/local/share/whisper.cpp && \
    cp -r /tmp/whisper.cpp/samples /usr/local/share/whisper.cpp/samples && \
    ldconfig && \
    rm -rf /tmp/whisper.cpp

ENV LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}

CMD ["/bin/bash"]
