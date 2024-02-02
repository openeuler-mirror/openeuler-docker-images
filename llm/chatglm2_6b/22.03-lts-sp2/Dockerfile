FROM openeuler/llm:fastchat-pytorch2.1.0.a1-cann7.0.RC1.alpha002-oe2203sp2

COPY chatglm2-6b.patch ./
COPY chatglm_inference.sh chatglm_finetune.sh stop_inference.sh /demo/
RUN chmod +x /demo/*.sh && \
    git clone https://huggingface.co/THUDM/chatglm2-6b && \
    cd chatglm2-6b && \
    git apply ../chatglm2-6b.patch