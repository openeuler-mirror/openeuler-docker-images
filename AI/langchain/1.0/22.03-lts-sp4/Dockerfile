FROM openeuler/openeuler:22.03-lts-sp4

LABEL author="yjh" description="langchain"

RUN dnf install -y python3-pip

RUN pip install --no-cache-dir langchain[all] \
    -i https://mirrors.aliyun.com/pypi/simple/
