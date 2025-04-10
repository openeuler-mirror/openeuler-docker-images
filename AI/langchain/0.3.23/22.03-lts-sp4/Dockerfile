ARG BASE=openeuler/openeuler:22.03-lts-sp4

FROM ${BASE}

LABEL author="yjh" description="langchain"

RUN dnf install -y python3-pip

RUN pip install --no-cache-dir langchain[all]==0.3.23 \
    -i https://mirrors.aliyun.com/pypi/simple/
