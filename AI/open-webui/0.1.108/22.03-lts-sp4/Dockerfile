FROM    openeuler/openeuler:22.03-lts-sp4

ARG TARGETARCH
ARG BUILDARCH

WORKDIR /root

RUN dnf install -y \
        git \
	wget \
	python3-pip

RUN git clone --branch v0.1.108 https://github.com/open-webui/open-webui.git

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="arm64"; \
    fi && \
    wget https://nodejs.org/download/release/v18.0.0/node-v18.0.0-linux-${BUILDARCH}.tar.gz && \
    tar -xvf node-v18.0.0-linux-${BUILDARCH}.tar.gz -C /usr/local && \
    ln -s /usr/local/node-v18.0.0-linux-${BUILDARCH}/bin/node /usr/local/bin/node && \
    ln -s /usr/local/node-v18.0.0-linux-${BUILDARCH}/bin/npm /usr/local/bin/npm

WORKDIR /root/open-webui

RUN npm config set registry https://registry.npmmirror.com/ && \
    npm i && \
    npm run build && \
    pip install pydantic -i https://mirrors.aliyun.com/pypi/simple/ && \
    pip install -r backend/requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ && \
    pip install fastapi_sso \
	transformers \
	accelerate

ENV HF_ENDPOINT=https://hf-mirror.com

CMD ["/bin/bash", "-c", "/root/open-webui/backend/start.sh"]

