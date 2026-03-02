ARG BASE=openeuler/openeuler:24.03-lts-sp3
ARG VERSION=v0.16.0

FROM ${BASE} AS base

ARG VERSION

RUN yum update -y && \
    yum install -y \
    ccache \
    git \
    curl \
    wget \
    ca-certificates \
    gcc \
    gcc-c++ \
    python \
    python-pip \
    python3-devel \
    git \
    ffmpeg \
    libSM \
    libXext \
    jq \
    lsof \
    numactl-devel && \
    yum clean all

WORKDIR /workspace

RUN git clone -b ${VERSION} https://github.com/vllm-project/vllm.git

WORKDIR /workspace/vllm

# Backport vllm-project/vllm PR #34052: fix mla_decode.cpp on x86_64 without
# AVX512BF16 by collapsing the s390x/aarch64 #elif chain into a single #else.
RUN python3 -c 'f="csrc/cpu/mla_decode.cpp"; c=open(f).read(); old="#elif defined(__s390x__)\ntemplate <>\nstruct KernelVecType<c10::BFloat16> {\n  using qk_load_vec_type = vec_op::BF16Vec16;\n  using qk_vec_type = vec_op::FP32Vec16;\n  using v_load_vec_type = vec_op::BF16Vec16;\n};\n\n#elif defined(__aarch64__)\ntemplate <>\nstruct KernelVecType<c10::BFloat16> {\n  using qk_load_vec_type = vec_op::BF16Vec16;\n  using qk_vec_type = vec_op::FP32Vec16;\n  using v_load_vec_type = vec_op::BF16Vec16;\n};\n#endif"; new="#else\ntemplate <>\nstruct KernelVecType<c10::BFloat16> {\n  using qk_load_vec_type = vec_op::BF16Vec16;\n  using qk_vec_type = vec_op::FP32Vec16;\n  using v_load_vec_type = vec_op::BF16Vec16;\n};\n#endif"; open(f,"w").write(c.replace(old,new,1))'

RUN pip install --extra-index https://download.pytorch.org/whl/cpu/ -r requirements/cpu.txt

FROM base AS build

RUN pip install -r requirements/cpu-build.txt

RUN VLLM_TARGET_DEVICE=cpu python3 setup.py bdist_wheel

FROM base AS release

COPY --from=build /workspace/vllm/dist /workspace/vllm/dist

RUN pip install dist/*.whl

WORKDIR /workspace

ENTRYPOINT ["python", "-m", "vllm.entrypoints.openai.api_server"]
