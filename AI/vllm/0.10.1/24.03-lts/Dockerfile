ARG BASE=openeuler/openeuler:24.03-lts
ARG VERSION=v0.10.1

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

RUN pip install -r requirements/cpu.txt

FROM base AS build 

RUN pip install -r requirements/cpu-build.txt

RUN VLLM_TARGET_DEVICE=cpu python3 setup.py bdist_wheel 

FROM base AS release

COPY --from=build /workspace/vllm/dist /workspace/vllm/dist

RUN pip install dist/*.whl

WORKDIR /workspace

ENTRYPOINT ["python", "-m", "vllm.entrypoints.openai.api_server"]
