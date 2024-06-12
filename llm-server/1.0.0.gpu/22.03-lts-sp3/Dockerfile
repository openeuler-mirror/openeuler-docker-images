FROM nvidia/cuda:12.1.1-devel-rockylinux9

RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirror.nju.edu.cn/rocky|g' \
         -i.bak \
         /etc/yum.repos.d/rocky-extras.repo \
         /etc/yum.repos.d/rocky.repo && \
    dnf -y update && \
    dnf -y install python3 python3-devel cmake gcc g++

RUN CMAKE_ARGS="-DLLAMA_CUDA=on" pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple -v guidance llama-cpp-python[server]

ENV KEY=sk-123456
ENV MODEL=/models/model.gguf
ENV MODEL_NAME=qwen-1.5
ENV CONTEXT=8192

EXPOSE 8000

ENTRYPOINT python3 -m llama_cpp.server --host 0.0.0.0 --port 8000 --api_key $KEY --model $MODEL --model_alias $MODEL_NAME --n_gpu_layers -1 --n_ctx $CONTEXT