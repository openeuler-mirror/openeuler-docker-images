ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=1.0.0

ENV LANG=C.UTF-8 \
    DEEPSEEK_HOME=/opt/DeepSeek-LLM \
    PATH=/opt/DeepSeek-LLM:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin 

RUN dnf -y update && \
    dnf -y install --nodocs --setopt=install_weak_deps=False \
        git wget curl python3 python3-pip gcc gcc-c++ make && \
    dnf clean all && rm -rf /var/cache/dnf

RUN pip3 install --no-cache-dir \
    torch \
    transformers \
    accelerate \
    sentencepiece \
    protobuf

WORKDIR /opt

RUN git clone --depth 1 https://github.com/deepseek-ai/DeepSeek-LLM.git ${DEEPSEEK_HOME}

WORKDIR ${DEEPSEEK_HOME}

RUN pip3 install --no-cache-dir -r requirements.txt

LABEL org.opencontainers.image.title="deepseek" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.description="DeepSeek-LLM training and inference environment"