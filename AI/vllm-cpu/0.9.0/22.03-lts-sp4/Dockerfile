ARG BASE=openeuler/openeuler:22.03-lts-sp4

FROM ${BASE}

ARG VERSION

RUN yum update -y && \
    yum install -y make gcc-toolset-12-gcc gcc-toolset-12-gcc-c++ python python-pip python3-devel git vim wget net-tools numactl-devel && \
    rm -rf /var/cache/yum

ENV PATH=/opt/openEuler/gcc-toolset-12/root/usr/bin/:$PATH
ENV LD_LIBRARY_PATH=/opt/openEuler/gcc-toolset-12/root/usr/lib64/:$LD_LIBRARY_PATH

WORKDIR /workspace

RUN git clone -b ${VERSION} https://github.com/vllm-project/vllm.git

WORKDIR /workspace/vllm

RUN pip install "cmake>=3.26" wheel packaging ninja "setuptools-scm>=8" numpy

RUN VLLM_TARGET_DEVICE="cpu" pip install -e . --extra-index-url https://download.pytorch.org/whl/cpu

ENTRYPOINT ["python", "-m", "vllm.entrypoints.openai.api_server"]