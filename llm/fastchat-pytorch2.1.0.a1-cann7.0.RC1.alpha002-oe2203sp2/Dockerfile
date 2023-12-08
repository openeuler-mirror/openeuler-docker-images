FROM openeuler/pytorch:pytorch2.1.0.a1-cann7.0.RC1.alpha002-oe2203sp2

COPY fastchat.patch ./
RUN git clone https://github.com/lm-sys/FastChat.git && \
    cd FastChat && \
    git apply ../fastchat.patch && \
    pip install -e ".[model_worker,webui]" -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install --no-cache-dir transformers==4.32.1 -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install --no-cache-dir accelerate==0.22.0 -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    rm -rf ../fastchat.patch