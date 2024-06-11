FROM hub.oepkgs.net/openeuler/openeuler:22.03-lts-sp3

RUN sed -i 's|http://repo.openeuler.org/|https://mirrors.huaweicloud.com/openeuler/|g' /etc/yum.repos.d/openEuler.repo &&\
    yum update -y &&\
    yum install -y python3 python3-pip shadow-utils cmake gcc g++ git make &&\
    yum clean all
RUN git clone https://github.com/OpenMathLib/OpenBLAS.git && \
    cd OpenBLAS && \
    make && \
    make install && \
    cd .. && \
    rm -rf OpenBLAS
RUN CMAKE_ARGS="-DLLAMA_BLAS=ON -DLLAMA_BLAS_VENDOR=OpenBLAS" pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple --no-cache-dir guidance llama-cpp-python[server]

ENV KEY=sk-123456
ENV MODEL=/models/model.gguf
ENV MODEL_NAME=qwen-1.5
ENV THREADS=8
ENV CONTEXT=8192

EXPOSE 8000

ENTRYPOINT python3 -m llama_cpp.server --host 0.0.0.0 --port 8000 --api_key $KEY --model $MODEL --model_alias $MODEL_NAME --n_threads $THREADS --n_ctx $CONTEXT