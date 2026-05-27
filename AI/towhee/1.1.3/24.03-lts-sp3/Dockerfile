FROM openeuler/openeuler:24.03-lts-sp3

ARG TOWHEE_VERSION=1.1.3

RUN dnf install -y python3-pip && dnf clean all

RUN pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple towhee==${TOWHEE_VERSION}
