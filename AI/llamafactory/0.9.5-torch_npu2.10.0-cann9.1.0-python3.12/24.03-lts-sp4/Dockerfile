# LlamaFactory Ascend NPU image on openEuler, following the official
# docker/docker-npu/Dockerfile and requirements of the LlamaFactory project
# (https://github.com/hiyouga/LlamaFactory).
FROM quay.io/ascend/torch-npu:2.10.0.post6-cann9.1.0-910b-openeuler24.03-py3.12

# Use PyPI directly; the base image pip.conf points at a mirror that is
# unreachable from the CI builders.
ENV PIP_INDEX_URL=https://pypi.org/simple

ARG VERSION=0.9.5

LABEL author="openEuler CloudNative SIG" description="LlamaFactory unified LLM fine-tuning framework with Ascend NPU support (torch_npu + CANN)"

# Expose port 7860 for LLaMA Board (WebUI) and 8000 for the API service
ENV GRADIO_SERVER_PORT=7860
ENV API_PORT=8000

# NPU constraints that keep the preinstalled torch/torch_npu stack untouched
RUN printf 'torch==2.10.0\ntorchvision==0.25.0\ntorchaudio==2.10.0\ntorch-npu==2.10.0.post7\n' > /opt/llamafactory-npu-constraints.txt

# Align TorchNPU with the version validated by the LlamaFactory NPU stack
# (requirements/npu.txt: torch-npu==2.10.0.post7) and install LlamaFactory
# from the official PyPI wheel, then the companion stack pinned by the
# upstream requirements (deepspeed.txt, metrics.txt, npu.txt extras)
RUN python3 -m pip install --no-cache-dir --no-deps torch-npu==2.10.0.post7 && \
    PIP_CONSTRAINT=/opt/llamafactory-npu-constraints.txt python3 -m pip install --no-cache-dir "llamafactory==${VERSION}" && \
    PIP_CONSTRAINT=/opt/llamafactory-npu-constraints.txt python3 -m pip install --no-cache-dir \
        "deepspeed>=0.10.0,<=0.18.4" nltk jieba rouge-chinese decorator && \
    python3 -m pip uninstall -y -q triton triton-ascend || true && \
    python3 -m pip install --no-cache-dir --no-deps \
        --index-url https://triton-ascend.osinfra.cn/pypi/simple/ \
        --trusted-host triton-ascend.osinfra.cn \
        triton-ascend==3.2.1 && \
    python3 -m pip cache purge

EXPOSE 7860 8000

CMD ["/bin/bash"]
