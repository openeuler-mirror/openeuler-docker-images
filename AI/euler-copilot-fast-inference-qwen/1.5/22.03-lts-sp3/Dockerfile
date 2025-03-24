ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

RUN yum upgrade -y && \
    yum -y install gcc make wget && \
    yum clean all

RUN mkdir -p /home/euler-copilot-fast-inference &&\
    cd /home/euler-copilot-fast-inference &&\
    wget https://hf-mirror.com/Qwen/Qwen1.5-1.8B-Chat-GGUF/resolve/main/qwen1_5-1_8b-chat-q4_0.gguf
ENV OMP_NUM_THREADS=16
COPY fast-llm /home/euler-copilot-fast-inference