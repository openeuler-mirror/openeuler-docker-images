ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=2.29.4

RUN dnf install -y python3-pip && \
    pip3 install --no-cache-dir "e2b==${VERSION}" \
    -i https://mirrors.aliyun.com/pypi/simple/ && \
    dnf clean all

CMD ["python3"]
