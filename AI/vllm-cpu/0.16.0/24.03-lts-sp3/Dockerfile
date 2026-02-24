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

# Backport fix for mla_decode.cpp compilation failure on x86_64 without AVX512BF16
# (vllm-project/vllm PR #34052). Replace arch-specific #elif chain with a single
# #else fallback so all non-AVX512BF16 platforms share the same FP32Vec16 path.
RUN python3 -c "
import re
path = 'csrc/cpu/mla_decode.cpp'
with open(path) as f:
    content = f.read()
old = (
    '#elif defined(__s390x__)\n'
    'template <>\n'
    'struct KernelVecType<c10::BFloat16> {\n'
    '  using qk_load_vec_type = vec_op::BF16Vec16;\n'
    '  using qk_vec_type = vec_op::FP32Vec16;\n'
    '  using v_load_vec_type = vec_op::BF16Vec16;\n'
    '};\n'
    '\n'
    '#elif defined(__aarch64__)\n'
    'template <>\n'
    'struct KernelVecType<c10::BFloat16> {\n'
    '  using qk_load_vec_type = vec_op::BF16Vec16;\n'
    '  using qk_vec_type = vec_op::FP32Vec16;\n'
    '  using v_load_vec_type = vec_op::BF16Vec16;\n'
    '};\n'
    '#endif'
)
new = (
    '#else\n'
    'template <>\n'
    'struct KernelVecType<c10::BFloat16> {\n'
    '  using qk_load_vec_type = vec_op::BF16Vec16;\n'
    '  using qk_vec_type = vec_op::FP32Vec16;\n'
    '  using v_load_vec_type = vec_op::BF16Vec16;\n'
    '};\n'
    '#endif'
)
assert old in content, 'Pattern not found - check mla_decode.cpp structure'
with open(path, 'w') as f:
    f.write(content.replace(old, new, 1))
print('Patch applied successfully')
"

RUN pip install --extra-index https://download.pytorch.org/whl/cpu/ -r requirements/cpu.txt

FROM base AS build 

RUN pip install -r requirements/cpu-build.txt

RUN VLLM_TARGET_DEVICE=cpu python3 setup.py bdist_wheel 

FROM base AS release

COPY --from=build /workspace/vllm/dist /workspace/vllm/dist

RUN pip install dist/*.whl

WORKDIR /workspace

ENTRYPOINT ["python", "-m", "vllm.entrypoints.openai.api_server"]

