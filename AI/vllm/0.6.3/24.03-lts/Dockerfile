# This vLLM Dockerfile is used to construct image that can build and run vLLM on x86 CPU platform.

FROM openeuler/openeuler:24.03-lts AS cpu-test-1

ENV CCACHE_DIR=/root/.cache/ccache

ENV CMAKE_CXX_COMPILER_LAUNCHER=ccache

RUN --mount=type=cache,target=/var/cache/yum \
    yum update -y \
    && yum install -y curl ccache git wget vim numactl gcc g++ python3-devel python3-pip gperftools-libs numactl-libs numactl-devel \
    && yum install -y ffmpeg libSM libXext mesa-libGL \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 10 --slave /usr/bin/g++ g++ /usr/bin/g++-12

# https://intel.github.io/intel-extension-for-pytorch/cpu/latest/tutorials/performance_tuning/tuning_guide.html
# intel-openmp provides additional performance improvement vs. openmp
# tcmalloc provides better memory allocation efficiency, e.g, holding memory in caches to speed up access of commonly-used objects.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install intel-openmp

ENV LD_PRELOAD="/usr/lib64/libtcmalloc_minimal.so.4:/usr/local/lib/libiomp5.so"

RUN echo 'ulimit -c 0' >> ~/.bashrc

RUN pip3 install intel_extension_for_pytorch==2.4.0

WORKDIR /workspace

RUN git clone https://github.com/vllm-project/vllm.git

ARG PIP_EXTRA_INDEX_URL="https://download.pytorch.org/whl/cpu"
ENV PIP_EXTRA_INDEX_URL=${PIP_EXTRA_INDEX_URL}
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install --upgrade pip && \
    pip install -r vllm/requirements-build.txt

# install oneDNN
RUN git clone -b rls-v3.5 https://github.com/oneapi-src/oneDNN.git

RUN --mount=type=cache,target=/root/.cache/ccache \
    cmake -B ./oneDNN/build -S ./oneDNN -G Ninja -DONEDNN_LIBRARY_TYPE=STATIC \ 
    -DONEDNN_BUILD_DOC=OFF \ 
    -DONEDNN_BUILD_EXAMPLES=OFF \ 
    -DONEDNN_BUILD_TESTS=OFF \ 
    -DONEDNN_BUILD_GRAPH=OFF \ 
    -DONEDNN_ENABLE_WORKLOAD=INFERENCE \ 
    -DONEDNN_ENABLE_PRIMITIVE=MATMUL && \
    cmake --build ./oneDNN/build --target install --config Release

FROM cpu-test-1 AS build

WORKDIR /workspace/vllm
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -v -r requirements-cpu.txt

# Support for building with non-AVX512 vLLM: docker build --build-arg VLLM_CPU_DISABLE_AVX512="true" ...
ARG VLLM_CPU_DISABLE_AVX512
ENV VLLM_CPU_DISABLE_AVX512=${VLLM_CPU_DISABLE_AVX512}

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/ccache \
    VLLM_TARGET_DEVICE=cpu python3 setup.py bdist_wheel && \
    pip install dist/*.whl && \
    rm -rf dist

WORKDIR /workspace/

RUN ln -s /workspace/vllm/tests && ln -s /workspace/vllm/examples && ln -s /workspace/vllm/benchmarks

ENTRYPOINT ["python3", "-m", "vllm.entrypoints.openai.api_server"]