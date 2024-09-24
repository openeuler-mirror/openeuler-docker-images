ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

RUN yum upgrade -y && \
    yum -y install gcc make && \
    yum clean all

RUN mkdir -p /home/euler-copilot-fast-inference
ENV OMP_NUM_THREADS=16
COPY fast-llm /home/euler-copilot-fast-inference
COPY qwen1_5-0_5b-chat-q4_0.gguf /home/euler-copilot-fast-inference