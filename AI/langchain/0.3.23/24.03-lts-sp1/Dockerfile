ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

LABEL author="ls" description="langchain"

RUN dnf install -y python3-pip

RUN pip install --no-cache-dir langchain[all]==0.3.23 \
    -i https://mirrors.aliyun.com/pypi/simple/
